unit niveau;

interface

uses Crt;

Type constituant = (pacpoints, dollars, dangerp, mur, vide);

Type cases = record
	objet: constituant;
end;

Type liste = array of Integer; 

Type labyrinthe = array [1..16,1..16] of cases; // tableau composé de toutes les cases du labyrinthe

procedure carte (var l: labyrinthe);
procedure pieges (var f,t: liste; var n : Integer; var l : labyrinthe);
procedure points (var l : labyrinthe);
procedure afficher (xj, yj, xm, ym : Integer; var l: labyrinthe);

Implementation

procedure carte (var l: labyrinthe); // initialisation du labyrinthe
var i, j : Integer;
begin
	for j := 1 to 15 do
		for i := 1 to 15 do
			l[i][j].objet := vide;
	// ligne 1
	i:= 6; 
	l[i][1].objet := mur;
	// ligne 2
	i:= 2;
	l[i][2].objet := mur;
	i:= 4;
	l[i][2].objet := mur;
	i:= 8;
	l[i][2].objet := mur;
	for i := 11 to 15 do
		l[i][2].objet := mur;
	// ligne 3
	for i := 2 to 5 do
		l[i][3].objet := mur;
	for i := 7 to 8 do
		l[i][3].objet := mur;
	// ligne 4
	i:= 7;
	l[i][4].objet := mur;	
	i:= 14;
	l[i][4].objet := mur;
	// ligne 5
	for i := 3 to 5 do
		l[i][5].objet := mur;
	i:= 7;
	l[i][5].objet := mur;
	for i := 9 to 12 do
		l[i][5].objet := mur;
	i:= 14;
	l[i][5].objet := mur;
	// ligne 6
	for i := 3 to 5 do
		l[i][6].objet := mur;	
	i:= 7;
	l[i][6].objet := mur;	
	i:= 9;
	l[i][6].objet := mur;
	for i := 11 to 12 do
		l[i][6].objet := mur;
	// ligne 7
	i:= 7;
	l[i][7].objet := mur;	
	i:= 9;
	l[i][7].objet := mur;
	i:= 11;
	l[i][7].objet := mur;	
	// ligne 8
	i:= 1;
	l[i][8].objet := mur;	
	for i := 3 to 7 do
		l[i][8].objet := mur;
	for i := 11 to 13 do
		l[i][8].objet := mur;
	// ligne 9
	i:= 3;
	l[i][9].objet := mur;
	i:= 13;
	l[i][9].objet := mur;
	// ligne 10
	for i := 2 to 3 do
		l[i][10].objet := mur;
	for i := 5 to 8 do
		l[i][10].objet := mur;
	for i := 10 to 13 do
		l[i][10].objet := mur;	
	// ligne 11
	i:= 3;
	l[i][11].objet := mur;	
	i:= 5;
	l[i][11].objet := mur;	
	i:= 8;
	l[i][11].objet := mur;
	// ligne 12
	i:= 1;
	l[i][12].objet := mur;
	i:= 3;
	l[i][12].objet := mur;	
	for i := 5 to 6 do
		l[i][12].objet := mur;
	i:= 8;
	l[i][12].objet := mur;
	for i := 10 to 14 do
		l[i][12].objet := mur;
	// ligne 13
	i:= 1;
	l[i][13].objet := mur;
	i:= 6;
	l[i][13].objet := mur;
	i:= 11;
	l[i][13].objet := mur;
	i:= 14;
	l[i][13].objet := mur;
	// ligne 14
	for i := 1 to 3 do
		l[i][14].objet := mur;	
	i:= 6;
	l[i][14].objet := mur;
	i:= 11;
	l[i][14].objet := mur;
	for i := 13 to 14 do
		l[i][14].objet := mur;	
	// ligne 15
	i:= 6;
	l[i][15].objet := mur;
	for i := 8 to 9 do
		l[i][15].objet := mur;
	i:= 13;
	l[i][15].objet := mur;		
	for i := 1 to 16 do
		l[i][16].objet := mur;
	for j := 2 to 15 do
		l[16][j].objet := mur;
end;

procedure pieges (var f, t: liste; var n : Integer; var l : labyrinthe);
var a, i, j: Integer;
begin
	{ajout d'un piège aléatoire parmi 5 emplacements dans le labyrinthe pour les niveaux impairs
	sauf pour le niveau 1}
	if ((n mod 2) = 1) and (n<>1) then
	begin
		randomize();
		// prend une valeur aléatoire dans la liste f qui représente un emplacement de pièges
		j := random(high(f));
		a := f[j];
		// remplacement de la valeur prise par la dernière valeur de la liste f 
		f[j]:= f[high(f)];
		// réduit la taille de la liste f de 1, ce qui supprime la dernière valeur de la liste 
		Setlength(f, length(f)-1);
		// augmente la taille de la liste t de 1
		Setlength(t, length(t)+1);
		// la dernière valeur de la liste t prend la valeur de celle prise dans la liste f
		t[high(t)] := a;
	end;
	// ajout du dernier piège aléatoire parmi les 5 pour le niveau 10
	if n = 10 then
	begin
		Setlength(t, length(t)+1);
		{la dernière valeur de la liste t prend la valeur de celle restante dans la liste f
		ce qui correspond au dernier piège aléatoire à mettre}
		t[high(t)] := f[0];
	end;
	// indique les 3 emplacements des pièges du début
	l[10][3].objet := dangerp;
	l[14][9].objet := dangerp;
	l[9][14].objet := dangerp;
	
	{permet de placer les pièges au bon emplacement en fonction des valeurs de la liste t
	ainsi que de les enregistrer dans cette liste pour les niveaux suivants} 
	for i := 0 to high(t) do
	case t[i] of 
		1:	l[1][1].objet := dangerp;
		2:	l[6][7].objet := dangerp;
		3:	l[15][7].objet := dangerp;
		4:	l[4][11].objet := dangerp;
		5:	l[12][11].objet := dangerp;
		end; 
end;

procedure points (var l : labyrinthe);
var i, j, n : Integer;
begin
	n:= 0;
	randomize();
	// place aléatoirement les 3 dollars d'un niveau
	repeat
		repeat
		i:= random(14) + 1;
		j:= random(14) + 1;
		until l[i][j].objet = vide;
		l[i][j].objet := dollars;
		n := n+1;
	until n=3;
	// place des pacpoints dans toutes les cases vides restantes du labyrinthe
	for i := 1 to 15 do
		for j := 1 to 15 do
			if l[i][j].objet = vide then
				l[i][j].objet := pacpoints;
	l[16][1].objet := pacpoints;
end;
	

procedure afficher (xj, yj, xm, ym : Integer; var l: labyrinthe); // affiche le labyrinthe
var i, j : Integer;
begin
	for j := 1 to 16 do
		for i := 1 to 16 do
				case l[i][j].objet of
					mur:begin
							// couleur blanche pour les murs
							TextColor(15);
							GotoXY(i,j);
							write('#');
						end; 
					dangerp:begin
								// couleur mauve clair pour les pièges
								TextColor(13);
								GotoXY(i,j);
								write('4');
							end;
					dollars:begin
								// couleur jaune pour les dollars
								TextColor(14);
								GotoXY(i,j);
								write('$');
							end;
					pacpoints:  begin
									// couleur cyan clair pour les pacpoints
									TextColor(11);
									GotoXY(i,j);
									write('o');
								end;
					vide:   begin
								GotoXY(i,j);
								write(' ');
							end;
				end;
	// couleur vert clair pour le joueur
	TextColor(10);
	GotoXY(xj,yj);
	write('J');
	// couleur rouge clair pour le monstre
	TextColor(12);
	GotoXY(xm,ym);
	write('M');
end;

begin
end.
