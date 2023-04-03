unit tableau;

interface

uses Crt;

Type classement = record // structure composé du nom, du score et du dernier niveau joué de chaque personnes présentes dans le classement
	nom : String; // correspond au nom du joueur
	score : Integer; // son score
	niv : Integer; // le dernier niveau qu'il a joué
end;

Type tabscore = array [1..10] of classement; // tableau qui contient toutes les infos du classement

procedure classementfin (s,n : Integer);

Implementation

procedure echanger (i : Integer; var tab : tabscore);
var k : Integer;
begin
	for k := 10 downto i+1 do // change le classement entre la 10ème place jusqu'à la place qui suit celle du joueur qui vient de jouer
		begin
			tab[k].nom := tab[k-1].nom; // déplace le nom du joueur à la place suivante dans le classement
			tab[k].score := tab[k-1].score; // déplace son score
			tab[k].niv := tab[k-1].niv; // déplace le dernier niveau qu'il a joué
		end;
end;

procedure trier (s, n : Integer; var tab : tabscore); // trie le classement en fonction du score du joueur qui vient de jouer
var i : Integer;
begin
	ClrScr;
	TextColor(15); // couleur blanche pour la demande du nom
	i := 0;
	repeat
		i := i+1;
	until (tab[i].score < s) or (i = 10); 
	// défile le classement jusqu'à ce que le score du joueur soit supérieur à un score du classement ou que son score soit inférieur au dernier score du classement
	if (s > tab[i].score) then // si son score est supérieur à une valeur du classement 
	begin
		echanger(i,tab); // change le classement
		tab[i].score := s; // met le score du joueur à sa place dans le tableau
		tab[i].niv := n; // met le dernier niveau qu'il a joué dans le tableau
		writeln('Entrez votre nom');
		readln(tab[i].nom); // met son nom dans le tableau 
	end;
end;

procedure affichagetab (tab : tabscore);
var j : Integer;
begin
	ClrScr;
	TextColor(11); // couleur cyan clair pour le titre
	GotoXY(10,2);
	write('Tableau des scores');
	TextColor(15); // couleur blanche pour le tableau
	for j := 1 to 10 do // affiche le nom, le score et le dernier niveau qu'il a joué, des 10 meilleurs joueurs du classement 
	begin
		GotoXY(1,j+3);
		writeln(j , ')'); // affiche les positions de 1 à 10
		GotoXY(5,j+3);
 		writeln(tab[j].nom); // affiche le nom des 10 meilleurs joueurs
		GotoXY(20,j+3);
		writeln(tab[j].score, ' points'); // affiche leur score
		GotoXY(35,j+3);
		if tab[j].niv < 11 then
		writeln('niveau ', tab[j].niv) // affiche le dernier niveau qu'ils ont joué si ils n'ont pas fini le jeu
		else
		writeln('niveau ', tab[j].niv - 1, '+'); // montre dans le classement que le joueur a fini le jeu 
	end;
end;

procedure initab (var tab : tabscore);
var i : Integer;
	f : TextFile;
begin
	assign(f,'tabsco.txt');
	reset(f);
	for i := 1 to 10 do // fait pour tous les joueurs du classement
	begin
		readln(f,tab[i].nom); // mets dans le tableau, le nom du joueur enregistré dans le fichier
		readln(f,tab[i].score); // son score enregistré dans le fichier
		readln(f,tab[i].niv); // le dernier niveau qu'il a joué, qui est enregistré dans le fichier
	end;
	close(f);
end;

procedure enregistrer (tab : tabscore);
var i : Integer;
	f : TextFile;
begin
	assign(f,'tabsco.txt');
	rewrite(f);
	for i := 1 to 10 do // fait pour tous les joueurs du classement
	begin
		writeln(f,tab[i].nom); // enregistre le nom du joueur
		writeln(f,tab[i].score); // son score
		writeln(f,tab[i].niv); // le dernier niveau qu'il a joué 
	end;
	close(f);
end;

procedure classementfin (s,n : Integer);
var tab : tabscore;
begin
	initab(tab); // remplit le tableau des infos du fichier
	trier(s,n,tab); // trie le tableau en fonction du score du joueur
	affichagetab(tab); // affiche à l'écran le tableau des scores
	enregistrer(tab); // enregistre la mise à jour du tableau de scores
end;

begin
end.
