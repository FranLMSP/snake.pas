unit libreriagrafica;

interface

uses crt,librerialogica;

procedure recuadro(x,y,x2,y2:byte);

procedure mostrar(color:byte;ini:lista;mostrar:boolean);

procedure mostrar_opciones(x,y,color,fondo:byte);

procedure mostrar_flechita(x,y:byte;caracter:char);

procedure mostrar_puntos(cant:byte;culebra1,culebra2:culebra);


implementation 

{
	* recuadro: procedimiento que dibuja un recuadro en la pantalla del tamaño deseado
		- variables de entrada:
		* x,y: posición de la esquina superior izquierda
		* x2,y2: posición de la esquina inferior derecha}

procedure recuadro(x,y,x2,y2:byte);
var
	i:byte;
BEGIN
	for i:=x to x2 do
	begin
		gotoxy(i,y);write('#');
		gotoxy(i,y2);write('#');
	end;
	for i:=y to y2 do
	begin
		gotoxy(x,i);write('#');
		gotoxy(x2,i);write('#');
	end;
END;

{"mostrar": procedimiento que muestra o borra a la culebra en pantalla
* color: color con el que se va a mostrar la culebra
* lista: culebra a imprimir
* mostrar: booleano
* 		-true: hace que muestre la culebra
* 		-false:hace que la borre}

procedure mostrar(color:byte;ini:lista;mostrar:boolean);
var
	a:lista;
BEGIN
	a:=ini;
	textcolor(color);
	while(a<>nil) do
	begin
		gotoxy(a^.infor.x,a^.infor.y);
		if mostrar then
			write(a^.infor.caracter)
		else
			write(' ');
		a:=a^.sig;
	end;
END;


procedure mostrar_opciones(x,y,color,fondo:byte);
BEGIN
	textbackground(fondo);textcolor(color);
	gotoxy(x,y);  write('Un jugador ');
	gotoxy(x,y+1);write('Dos jugadores');
	gotoxy(x,y+2);write('Records');
END;

procedure mostrar_flechita(x,y:byte;caracter:char);
BEGIN
	gotoxy(x,y-1);write(caracter);
END;

procedure mostrar_puntos(cant:byte;culebra1,culebra2:culebra);
BEGIN
	textcolor(culebra1.color);
	gotoxy(1,24);
	write('              ');
	gotoxy(1,24);
	write('Puntos J1: ',largo(culebra1.inicio));
	if cant>1 then
	begin
		textcolor(culebra2.color);
		gotoxy(65,24);
		write('              ');
		gotoxy(65,24);
		write('Puntos J2: ',largo(culebra2.inicio));
	end;
END;

	
END.
