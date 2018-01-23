program evaluacion;

uses crt,librerialogica,libreriagrafica;

label
	inicio;
var
	culebrita,culebrita2:culebra;
	perder:boolean;
	r,comida:snake;
	cant_jugadores:byte;
	key:char;
	p:jugador;

BEGIN
	clrscr;
	inicio:
	recuadro(4,2,76,23);
	cant_jugadores:=1;
	mostrar_opciones(35,11,white,black);
	perder:=false;
	//mostrar_flechita(32,11+cant_jugadores,'>');
	repeat
		gotoxy(32,11);write(' ');
		gotoxy(32,12);write(' ');
		gotoxy(32,13);write(' ');
		mostrar_flechita(32,11+cant_jugadores,'>');
		seleccionar_opcion(cant_jugadores,key);
	until key=ENTER;
	clrscr;
	if cant_jugadores=3 then
	begin
		mostrar_record(nombre_archivo);
		readkey;
		clrscr;
		goto inicio;
	end;
	clrscr;
	recuadro(4,2,76,23);
	//PROGRAMA PRINCIPAL
	perder:=false;
	
	//summonear culebrita 1
	culebrita.inicio:=nil;
	r.x := 60; r.y := 15; r.caracter := '@';
	crecer(5,r,culebrita.inicio);
	culebrita.inicio^.infor.caracter:='+';
	culebrita.direccion:=3;
	culebrita.color:=lightblue;
	//summonear culebrita 2
	if cant_jugadores=2 then
	begin
		culebrita2.inicio:=nil;
		r.x := 20; r.y := 15; r.caracter := '@';
		crecer(5,r,culebrita2.inicio);
		culebrita2.inicio^.infor.caracter:='+';
		culebrita2.direccion:=4;
		culebrita2.color:=lightred;
	end;
	
	randomize;
	aparecer_comida(cant_jugadores,culebrita.inicio^.infor.x,culebrita.inicio^.infor.y,comida);
	
	
	repeat
		mostrar_puntos(cant_jugadores,culebrita,culebrita2);
		mostrar(culebrita.color,culebrita.inicio,true);
		if cant_jugadores=2 then
			mostrar(culebrita2.color,culebrita2.inicio,true);
		
		delay(velocidad);
		
		mostrar(culebrita.color,culebrita.inicio,false);
		if cant_jugadores=2 then
			mostrar(culebrita2.color,culebrita2.inicio,false);
		
		cambiar_direccion(cant_jugadores,culebrita.direccion,culebrita2.direccion);
		
		mover(culebrita);
		if cant_jugadores=2 then
			mover(culebrita2);
			
		perder:=choca(culebrita.inicio^.infor.x,culebrita.inicio^.infor.y,culebrita.inicio);
		
		if cant_jugadores=2 then
			perder:=choca(culebrita.inicio^.infor.x,culebrita.inicio^.infor.y,culebrita.inicio) or
					choca(culebrita2.inicio^.infor.x,culebrita2.inicio^.infor.y,culebrita2.inicio) or
					choca(culebrita.inicio^.infor.x,culebrita.inicio^.infor.y,culebrita2.inicio) or
					choca(culebrita2.inicio^.infor.x,culebrita2.inicio^.infor.y,culebrita.inicio);
		if cant_jugadores=1 then
			comio(culebrita.inicio^.infor.x,culebrita.inicio^.infor.y,cant_jugadores,comida, culebrita.inicio,culebrita.inicio)
		else
		begin
			comio(culebrita2.inicio^.infor.x, culebrita2.inicio^.infor.y, cant_jugadores, comida, culebrita2.inicio, culebrita.inicio);
			comio(culebrita.inicio^.infor.x,  culebrita.inicio^.infor.y,  cant_jugadores, comida, culebrita.inicio,  culebrita2.inicio);
			
		end;
	until (perder);
	
	clrscr;	
	if cant_jugadores =2 then
	begin
		if largo(culebrita.inicio)>largo(culebrita2.inicio) then
		begin
			textcolor(culebrita.color);
			p.puntos:=largo(culebrita.inicio);
		end
		else
		begin
			textcolor(culebrita2.color);
			p.puntos:=largo(culebrita2.inicio);
		end;
	end
	else
	if cant_jugadores=1 then
	begin
		p.puntos:=largo(culebrita.inicio);
		textcolor(culebrita.color);
	end;
		
	gotoxy(3,13);write('Nombre: ');textcolor(lightgray); gotoxy(14,13);read(p.nombre);
	guardar_record(nombre_archivo,p);
	clrscr;
	goto inicio;



END.

