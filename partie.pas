program partie;

uses Crt, niveau, tableau;

procedure deplacement(var xj,yj,xja,yja : Integer ; var l : labyrinthe); // permet de déplacer le joueur
var c : Char;
begin
	//xja et yja sont les précédents xj et yj
	xja:= xj;
	yja:= yj;
	// enregistre avec 2 variables la position du joueur avant qu'il se déplace
	if keypressed() then // permet de faire bouger le monstre même si le joueur ne bouge pas
	begin
	c:= ReadKey;
	case c of
		#72 : begin
				if l[xj][yj-1].objet <> mur then
					 yj := yj-1; // déplace le joueur en haut
				end;
		#80 : begin
				if l[xj][yj+1].objet <> mur then
					 yj := yj+1; // déplace le joueur en bas
				end;
		#75 : begin
				if l[xj-1][yj].objet <> mur then
					 xj := xj-1; // déplace le joueur à gauche
				end;
		#77 : begin
				if l[xj+1][yj].objet <> mur then
					 xj := xj+1; // déplace le joueur à droite
				end;
		end;
	if xj < 1 then
		xj := 1; // permet de pas faire sortir le joueur du labyrinthe par la gauche
	if yj < 1 then
		yj := 1; // permet de pas faire sortir le joueur du labyrinthe par le haut
	end;
end; 

procedure monstre (var xm,ym,xma,yma : Integer; var l : labyrinthe); // permet de déplacer le monstre
var a, b : Integer;
begin
	//xma et yma sont les précédents xm et ym
	xma:= xm;
	yma:= ym;
	// enregistre avec 2 variables la position du monstre avant qu'il se déplace
	a:= random(99); // permet de déplacer aléatoirement le monstre
	b:= a mod 4;
	case b of
		0: if (l[xm][ym-1].objet <> mur) and (ym-1 > 0) then
				ym := ym-1; // déplace le joueur en haut
		1: if (l[xm+1][ym].objet <> mur) and (xm+1 < 16) then
				xm := xm+1; // déplace le joueur à droite
		2: if l[xm][ym+1].objet <> mur then
				ym := ym+1; // déplace le joueur en bas
		3: if (l[xm-1][ym].objet <> mur) and (xm-1 > 0) then
				xm := xm-1; // déplace le joueur à gauche
	end;
end;

procedure test(xja,yja : Integer; var xj,yj,score,vie,dol : Integer; var l : labyrinthe);
begin
	if l[xj][yj].objet = pacpoints then // si le joueur arrive sur un pacpoint
		begin
			l[xj][yj].objet := vide;
			score := score + 10; //gain de points des pacpoints
		end
	else if l[xj][yj].objet = dollars then // si le joueur arrive sur un dollar
		begin
			l[xj][yj].objet := vide;
			score := score + 200; //gain de points des dollars
			dol := dol - 1;
			//dol compte le nombre de dollars encore présents dans le labyrinthe
		end
	else if l[xj][yj].objet = dangerp then // si le joueur arrive sur un piège
		begin
			xj:= xja;
			yj:= yja;
			//le joueur revient à sa position précédente 
			vie := vie - 1;
			//perte de vies à cause des pièges
			TextColor(13);
			GotoXY(xj,yj);
			write('J');
			delay(1500);
			//affichage du joueur en mauve clair qui s'est pris un piège
		end;
end;

procedure testmonstre(xj,yj,xm,ym : Integer; var vie : Integer);
begin
	if (xj=xm) and (yj=ym) then
		vie := vie - 1; // perte de vie si le joueur est au même endroit que le monstre
end; 

procedure affichej(xj,yj,xja,yja : Integer; l : labyrinthe);
begin
	TextColor(10);
	GotoXY(xj,yj);
	write('J'); // affiche le joueur à sa place
	GotoXY(xj,yj); // permet d'avoir le curseur sur le joueur			
	if (xj<>xja) or (yj<>yja) then // si le joueur a bougé, affiche une case vide à l'endroit où il était avant 
		begin
			GotoXY(xja,yja); 
			write(' ');
			GotoXY(xja,yja); // permet d'avoir le curseur sur le joueur
		end;
end;

procedure affichem(xm,ym,xma,yma : Integer; l : labyrinthe);
begin
	TextColor(12);
	GotoXY(xm,ym);
	write('M'); // affiche le monstre à sa place
	if (xm<>xma) or (ym<>yma) then // si le monstre a bougé, affiche le constituant de la case où il était avant	
		begin
			GotoXY(xma,yma); // place le curseur à la case précédente du monstre
			case l[xma][yma].objet of
				dangerp:begin
							//couleur mauve clair pour les pièges
							TextColor(13);
							write('4'); // affiche un piège si la case précédente du monstre était un piège
						end;
				dollars:begin
							//couleur jaune pour les dollars
							TextColor(14);
							write('$'); // affiche un dollar si la case précédente du monstre était un dollar
						end;
				pacpoints:  begin
								//couleur cyan clair pour les pacpoints
								TextColor(11);
								write('o'); // affiche un pacpoint si la case précédente du monstre était un pacpoint
							end;
				vide:	write(' '); // affiche une case vide si la case précédente du monstre était vide
			end;
		end;
end;

procedure affichesup(n, score, vie : Integer; var ind : Boolean); // permet d'afficher des informations sur la partie à droite du labyrinthe
var c : Char;
	x, y : Integer;
begin
	TextColor(15);
	GotoXY(20,2);
	write('Niveau ', n); // affiche le niveau auquel le joueur est en train de jouer	
	TextColor(10);
	GotoXY(20,5);
	write('Score : ', score ,' points'); // affiche le nombre de points en direct du joueur
	TextColor(12);
	GotoXY(20,8);
	write('Nombre de vies : ', vie); // affiche le nombre de vies en direct du joueur
	GotoXY(20,10);
	TextColor(15);
	case ind of
		True :	begin // ind est vrai si les indications ne sont pas affichées
					write('Si vous voulez des indications, appuyez sur i'); // indique au joueur d'appuyer sur i pour avoir les indications
					for x := 1 to 8 do
					write(' '); // enlève les lettres qui dépassent de la phrase
				end;
		False : write('Si vous voulez enlever les indications, appuyez sur e'); // indique au joueur d'appuyer sur e pour retirer les indications
		// ind est faux si les indications sont affichées
	end;
	if keypressed() then
	begin
		c:= ReadKey;
		if (c = 'i') and (ind = True) then // si le joueur appuies sur i et que ind vaut vrai, alors les indications s'affichent
		begin
			GotoXY(20,11);
			write('Indications:');
			GotoXY(20,12);
			write('4 : piège');
			GotoXY(20,13);
			write('M : monstre');
			GotoXY(20,14);
			write('o : pacpoints');
			GotoXY(20,15);
			write('J : joueur');
			ind := False; // ind prend la valeur faux car les indications viennent d'être affichées
		end;
		if (c = 'e') and (ind = False) then // si le joueur appuies sur e et que ind vaut faux, alors les indications s'enlèvent
		begin
			for y := 11 to 15 do
				for x := 20 to 32 do
					begin
						GotoXY(x,y);
						write(' '); // retire tous les caractères des indications
					end;
			ind := True; // ind prend la valeur vrai car les indications viennent d'être retirées
		end;
	end;
end;

procedure initialisation (var n, s, vie, dolfin : Integer; var f, t : liste; var c:Char);
// permet d'initialiser les variables et les tableaux qui changeront tout au long du jeu
var i : Integer;
begin
	n:= 1;
	s:= 0;
	vie:= 3;
	dolfin:= 0;
	Setlength(f, 5);
	for i := 0 to 4 do
		f[i]:= i+1;
	Setlength(t, 0);
	c := 'a';
end;

procedure regles (c : Char); // permet d'afficher les règles pour que le joueur comprenne le jeu avant qu'il joue
begin
	TextColor(11); //couleur cyan clair pour le titre du jeu
	GotoXY(20,2);
	write('PAC-SQUARE');
	GotoXY(5,4);
	Textcolor(15); //couleur blanche pour les règles
	write('Votre objectif est d''avoir le plus de points.');
	GotoXY(5,5);
	write('Vous gagnez des points en prenant :');
	GotoXY(5,6);
	write('- les pacpoints valant 10 points');
	GotoXY(5,7);
	write('- les dollars valant 200 points');
	GotoXY(5,9);
	write('Attention un monstre et des pieges se trouvent dans le labyrinthe, pour vous faire perdre des vies !');
	GotoXY(5,11);
	write('La sortie du niveau est en haut à droite.');
	GotoXY(5,12);
	write('Il y a 10 niveaux au total.');
	GotoXY(5,13);
	write('Vous pouvez avoir des indications sur les symboles lors du jeu.');
	GotoXY(5,15);
	TextColor(10); //couleur verte pour les bonus
	write('Bonus :');
	GotoXY(5,16);
	write('- Si vous prenez les 3 dollars d''un niveau, vous gagnez une vie à la fin de ce niveau');
	GotoXY(5,18);
	write('- Si vous finissez le dernier niveau avec plus de 3 vies, chaque vie de plus vous rapportera 500 points');
	GotoXY(5,20);
	write('- Si vous recuperez tous les dollars des 10 niveaux et que vous finissez le jeu, vous obtiendrez un bonus de 2000 points');
	repeat
		TextColor(12); //couleur rouge pour lancer le jeu
		GotoXY(5,22);
		write('Pour commencer le jeu, appuyez sur s');
		c:= ReadKey;
	until c = 's'; // lance le jeu dès que le joueur a appuyé sur s
end;

procedure level(var n,s,vie,dolfin : Integer; var f, t : liste); // permet de faire fonctionner un niveau entier
var	l : labyrinthe;
	xj, yj, xja, yja, xm, ym, xma, yma, dol, i : Integer;
	c : Char;
	ind : Boolean;
begin
	ClrScr;
	TextColor(15);
	GotoXY(8,5);
	write('Niveau ', n); // affiche le numéro du niveau avant que celui-ci commence
	delay(1500);
	carte(l); // remplit de murs le labyrinthe du niveau
	pieges(f,t,n,l); // remplit de pièges le labyrinthe du niveau en fonction du numéro de celui-ci
	points(l); // remplit de dollars et de pacpoints le labyrinthe du niveau
	xj:= 1;
	yj:= 15; // place le joueur en bas à gauche à chaque début de niveau
	xm:= 10;
	ym:= 4; // place le monstre à chaque début de niveau
	dol:= 3; // le nombre de dollars présents dans le labyrinthe est de 3 pour chaque début de niveau
	i:= 0;
	ind:= True; // ind vaut vrai car à chaque début de niveau il n'y a pas les indications d'afficher
	ClrScr;
	afficher(xj,yj,xm,ym,l); // affiche le labyrinthe du niveau
	if keypressed() then 
	begin
		c:= ReadKey;
		if (c = #77) then
		begin
			xj := 1;
			yj := 15;
		end; 
	end;
	// permet de ne pas faire bouger le joueur au début d'un niveau si il a appuyé plusieurs fois sur la touche pour aller à droite à la fin du précédent
	repeat 
		affichesup(n,s,vie,ind); // affiche les informations du niveau en cours
		deplacement(xj,yj,xja,yja,l); // déplace le joueur si il a appuyé sur les touches de déplacement
		test(xja,yja,xj,yj,s,vie,dol,l); // change son nombre de points et de vies en fonction de sa position
		affichej(xj,yj,xja,yja,l); // affiche le joueur à sa case, et affiche une case vide à la position précédente du joueur
		testmonstre(xj,yj,xm,ym,vie); // change le nombre de vies en fonction de la position du joueur et de celle du monstre
		if i mod 11-n <> 1 then // permet de ne pas tout le temps faire déplacer le monstre
		begin
			monstre(xm,ym,xma,yma,l); // déplace le monstre aléatoirement
			delay(160-10*n); // permet de réguler la vitesse de déplacment du monstre, et permet d'augmenter celle-ci en fonction du niveau
		end;
		testmonstre(xj,yj,xm,ym,vie); // change le nombre de vies en fonction de la position du joueur et de celle du monstre
		affichem(xm,ym,xma,yma,l); // affiche le monstre à sa case, et affiche le constituant de la position précédente du monstre
		i:= i + 1;
	until ((xj = 17) and (yj = 1)) or (vie < 1); // déroulement du niveau jusqu'à que le joueur l'ait fini ou que ce dernier n'ait plus de vies
	ClrScr;
	TextColor(10);
	if (dol = 0) and (vie > 0) then // ajoute une vie si le joueur a passé le niveau en récupérant les 3 dollars de celui-ci
		begin
			vie:= vie + 1;
			dolfin:= dolfin + 1; // permet de savoir à la fin si le joueur a récupéré tous les dollars du jeu 
			GotoXY(8,3);
			write('Bien joue, vous avez recupere tous les dollars!');
		end;
	if vie > 0 then // si le jeu a encore des vies, il passe au niveau suivant
		n:= n + 1;
	GotoXY(8,5);
	write('Votre score est de ', s ,' points!');
	GotoXY(8,6);
	writeln('Il vous reste encore ' , vie, ' vies!');
	delay(3000); // fais un bilan du nombre de points et de vies du joueur avant la fin du jeu ou le début du niveau suivant
end;

procedure bonusfin(var s,vie,dolfin : Integer); 
begin
	if vie > 3 then // si le joueur finit tous les niveaux avec plus de 3 vies, chaque vie supplémentaire lui rapporte 500 points 
	s := s + (vie-3)*500;
	if dolfin = 10 then // si le joueur a récupéré tous les dollars du jeu, il obtient un bonus de 2000 points
	s := s + 2000;
end;	

procedure affichagefin (n, s : Integer);
begin
	ClrScr;
	TextColor(10);
	GotoXY(8,3);
	if n = 11 then
		write('Bravo vous avez reussi tous les niveaux !')
	else if n = 1 then
		write('Dommage vous ferez mieux la prochaine fois !')
	else
		write('Bravo vous avez reussi ' , n-1 ,' niveaux !'); // affiche un petit message en fonction du dernier niveau joué par le joueur
	GotoXY(8,5);
	write('Votre score total est de ', s ,' points!');
	delay(3000); // affiche le score final du joueur
end;	

var n, s, vie, dolfin : Integer;
	f, t : liste;
	c : Char; 
begin
	initialisation(n,s,vie,dolfin,f,t,c); // initialise les variables et les tableaux qui changeront tout au long du jeu
	regles(c); // affiche les règles avant que le joueur décide de lancer le jeu
	repeat
		level(n,s,vie,dolfin,f,t); // déroulement d'un niveau
	until (n > 10) or (vie < 1); // déroulement de la partie jusqu'à ce que le joueur ait fini les 10 niveaux ou qu'il n'ait plus de vies
	bonusfin(s,vie,dolfin); // ajoute les bonus finaux en fonction du nombre de dollars récupérés et du nombre final de vie du joueur
	affichagefin(n,s); // affiche les infos de la fin du jeu
	classementfin(s,n); // demande le nom du joueur si son score lui permet d'être dans le classement, affiche le tableau des scores 
end.
