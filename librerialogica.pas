unit librerialogica;

interface

uses crt;

const
	limite_izquierdo = 5;
	limite_derecho	 = 75;
	limite_arriba	 =3;
	limite_abajo	 =22;
	
	velocidad	= 90;
	ARRIBA		= #72;
	ABAJO		= #80;
	IZQUIERDA	= #75;
	DERECHA		= #77;
	ENTER		= #13;
	nombre_archivo='save.dat';
	

type
	snake=record
		x,y:byte;
		caracter:char;
	end;
	lista=^nodo;
	nodo=record
		infor:snake;
		sig,ant:lista;
	end;
	culebra=record
		direccion,color:byte;
		inicio:lista;
	end;
	
	jugador=record
		nombre:string;
		puntos:integer;
	end;
	
	
procedure mover(var a:culebra);

procedure insertar_inicio(cuerpo:snake; var ini:lista);

procedure cambiar_direccion(cant:byte;var a,b:byte);

procedure insertar_final(newreg:snake; var inicio:lista);

procedure borrar_ultimo(var inicio:lista);

procedure aparecer_comida(jugadores:byte;culebrax,culebray:byte;var food:snake);

function choca(x,y:byte; ini:lista):boolean;

procedure crecer(veces:byte;r:snake;var a:lista);

procedure comio(culebrax,culebray,cant:byte; var comida:snake; var culebra1,culebra2:lista);

procedure decrecer(cantidad:byte;var ini:lista);

procedure explotar(var culebra:lista);

procedure seleccionar_opcion(var opcion:byte;var key:char);

function largo(a:lista):integer;

procedure crear_archivo(nombre_arch:string);

procedure guardar_record(nombre_arch:string; r:jugador);

procedure mostrar_record(nombre_arch:string);

implementation 


{
	* insertar_inicio: Procedimiento que permite insertar un nodo al inicio de la lista
	- Tiene como datos de entrada:
	* cuerpo de tipo snake: contiene la información de el nodo a insertar
	* ini de tipo lista (por referencia): la lista a la cual se le va a insertar el nodo}

procedure insertar_inicio(cuerpo:snake; var ini:lista);
var
	aux:lista;
BEGIN
	new(aux);
	aux^.infor:=cuerpo;
	aux^.sig:=ini;
	ini:=aux;
	aux:=nil;
END;

{
	* insertar_inicio: Procedimiento que permite insertar un nodo al final de la lista
	- Tiene como datos de entrada:
	* newreg de tipo snake: contiene la información de el nodo a insertar
	* ini de tipo lista (por referencia): la lista a la cual se le va a insertar el nodo}

procedure insertar_final(newreg:snake; var inicio:lista);
var
	temp,aux:lista;
BEGIN
	temp:=inicio;
	if (temp=nil)then
	begin
		new(temp);
		temp^.sig:=nil;
		temp^.infor:=newreg;
		inicio:=temp;
		temp:=nil;
	end
	else
	begin
		while(temp^.sig<>nil)do
			temp:=temp^.sig;
		new(aux);
		aux^.sig:=nil;
		aux^.infor:=newreg;
		temp^.sig:=aux;
		aux:=nil;
	end;
END;

{
	* "borrar_ultimo: procedimiento que permite borrar un último nodo de una lista.
		Tiene como dato de entrada "inicio" de tipo lista por referencia: Lista
		a la cual se le va a borrar el último nodo.}

procedure borrar_ultimo(var inicio:lista);
var
	a,ant:lista;
BEGIN
	a:=inicio;
	while(a^.sig<>nil)do
	begin
		ant:=a;
		a:=a^.sig;
	end;
	ant^.sig:=nil;
	dispose(a);
END;

{
	* procedimiento "mover": hace que la culebra cambie su posición en la pantalla dependiendo
							de la dirección a la que esté apuntando.
							* 1:arriba
							* 2:abajo
							* 3:derecha
							* 4:izquierda
	Por referencia tiene la variable de la culebra}
	
function largo(a:lista):integer;
var
	aux:lista;
BEGIN
	aux:=a;
	largo:=0;
	while aux<>nil do
	begin
		largo:=largo+1;
		aux:=aux^.sig;
	end;
END;

procedure mover(var a:culebra);
var
	cuerpo:snake;
	aux:lista;
BEGIN
	cuerpo:=a.inicio^.infor;
	case a.direccion of
		1:cuerpo.y:=cuerpo.y-1;
		2:cuerpo.y:=cuerpo.y+1;
		3:cuerpo.x:=cuerpo.x-1;
		4:cuerpo.x:=cuerpo.x+1;
	end;
	if largo(a.inicio)=1 then
	begin
		a.inicio^.infor.x:=cuerpo.x;
		a.inicio^.infor.y:=cuerpo.y;
	end
	else
	begin
		insertar_inicio(cuerpo,a.inicio);
		borrar_ultimo(a.inicio);
		aux:=a.inicio;
		aux:=aux^.sig;
		aux^.infor.caracter:='@';
	end;
		
END;

{
	* "cambiar_direccion": procedimiento que lee una tecla pulsada y cambia
							la dirección de las culebritas.
							* 1: arriba
							* 2: abajo
							* 3: izquierda
							* 4: derecha}

procedure cambiar_direccion(cant:byte;var a,b:byte);
var
	tecla:char;
BEGIN
	if keypressed then
	begin
		tecla:=readkey;
		if tecla=#0 then
			tecla:=readkey;
		case tecla of
				ARRIBA:		if a<> 2 then a:=1;
				ABAJO:		if a<> 1 then a:=2;
				IZQUIERDA:	if a<> 4 then a:=3;
				DERECHA:	if a<> 3 then a:=4;
				'w':	if cant=2 then if b<> 2 then b:=1;
				's':	if cant=2 then if b<> 1 then b:=2;
				'a':	if cant=2 then if b<> 4 then b:=3;
				'd':	if cant=2 then if b<> 3 then b:=4;
				'p':	repeat
							tecla:=readkey;
						until tecla='p';
		end;
	end;
END;

{
	*"aparecer_comida": aparece una comida al azar en un sitio al azar de la pantalla. 
		como dato de entrada tiene:
		* jugadores: la cantidad de jugadores, para saber qué tipo de comidas pueden aparecer.
		* culebrax,culebray: posiciones x,y de las culebras para evitar que la comida aparezca sobre ellas
		* food: la comida a aparecer
	}

procedure aparecer_comida(jugadores:byte;culebrax,culebray:byte;var food:snake);
var
	car:char;
	num:byte;
BEGIN
	textcolor(green);
	randomize;
	if jugadores=1 then
		num:=random(3)
	else
		num:=random(7);
	case num of
		0:car:='a';
		1:car:='b';
		2:car:='c';
		3:car:='d';
		4:car:='y';
		5:car:='e';
		6:car:='r';
		7:car:='s';
	end;
	food.caracter:=car;
	repeat
		food.x:=random(71)+5;
		food.y:=random(20)+3;
	until ((food.x<>culebrax) and (food.y<>culebrax));
	gotoxy(food.x,food.y);write(food.caracter);
END;


{
	* "choca" función que retorna un booleano que permite saber si la culebrita chocó con la pared o con otra culebrita.
	* x,y: posiciones x,y de la cabeza de la culebrita
	* ini de tipo lista: culebrita propia o enemiga a evaluar}

function choca(x,y:byte; ini:lista):boolean;
var
	a:lista;
BEGIN
	choca:=false;
	a:=ini;
	a:=a^.sig;
	while((a<>nil) and (choca=false))do
	begin
		if (a^.infor.x=x) and (a^.infor.y=y) then
			choca:=true
		else
			a:=a^.sig;
	end;
	if choca=false then
	begin
		if (ini^.infor.x = limite_derecho+1) or (ini^.infor.x = limite_izquierdo-1) or (ini^.infor.y = limite_arriba-1) or (ini^.infor.y = limite_abajo+1) then
			choca:=true;
	end;
END;

{
	* "crecer": procedimiento que permite hacer crecer a la culebrita las veces deseadas
	* veces: cantidad de unidades a la que la culebrita va a crecer
	* r:información de la nueva unidad a añadir
	* a:culebra a crecer}

procedure crecer(veces:byte;r:snake;var a:lista);
var
	i:byte;
BEGIN
	for i:=1 to veces do
	begin
		insertar_final(r,a);
	end;
END;

{
	* "comio":procedimiento que pregunta si la posición de la cabeza de una culebrita es igual a la de la comida para darle un efecto.
	* culebrax,culebray:posición de la cabeza de la culebra
	* cant:cantidad de jugadores
	* comida:qué letra comió para saber qué efecto asignarles
	* culebra1:culebra que comió.
	* culebra2:culebra a la que le caerá el efecto
	* perdio:booleano que permite saber cuando una de las culebras ha perdido}

procedure comio(culebrax,culebray,cant:byte; var comida:snake; var culebra1,culebra2:lista);
var
	crecimientos,mitad:byte;
	r:snake;
BEGIN
	
	if (culebrax=comida.x) and (culebray=comida.y)then
	begin
		r.x:=culebrax;r.y:=culebray;r.caracter:='@';
		case comida.caracter of
			'a':crecimientos:=1;
			'b':crecimientos:=3;
			'c':crecimientos:=5;
			'd':crecimientos:=10;
			'y':if largo(culebra2) > 2 then decrecer(2,culebra2);
			'e':explotar(culebra2);
			'r':begin
					if largo(culebra2)>1 then
					begin
						mitad:=largo(culebra2) div 2;
						decrecer(mitad,culebra2); //decrecer(cantidad:byte;var ini:culebra);
						crecer(mitad,r,culebra1); //crecer(veces:byte;r:snake;var a:culebra);
					end;
				end;
			's':begin
				end;
		end;

			if comida.caracter in['a','b','c','d'] then
				crecer(crecimientos,r,culebra1);
			aparecer_comida(cant, culebra1^.infor.x,culebra1^.infor.y, comida);
			aparecer_comida(cant, culebra2^.infor.x,culebra2^.infor.y, comida);

	end;
END;

{
	* "decrecer": hace restarle a una culebra las unidades deseadas
	* cantidad: unidades a restar
	* ini: culebra a la que se le restaran unidades}

procedure decrecer(cantidad:byte;var ini:lista);
var
	i:byte;
BEGIN
	for i:=1 to cantidad do
	begin
		borrar_ultimo(ini);
	end;
END;

{
	* "explotar": hace que el cuerpo de la culebra explote en posiciones al azar}

procedure explotar(var culebra:lista);
var
	aux:lista;
BEGIN
	aux:=culebra;
	
	aux:=aux^.sig;
	while(aux<>nil)do
	begin
		aux^.infor.x:=random(71)+6;
		aux^.infor.y:=random(20)+3;
		aux:=aux^.sig;
	end;
	
	//culebra:=aux;
END;

{
	* "seleccionar_opcion": pregunta la opción seleccionada en el menú principal
	* opcion: numero de la opcion seleccionada
	* key: tecla pulsada}

procedure seleccionar_opcion(var opcion:byte;var key:char);
BEGIN
		key:=readkey;
		case key of
			ARRIBA:	if opcion>1 then opcion:=opcion-1;
			ABAJO:	if opcion<3 then opcion:=opcion+1;
		end;

END;

procedure crear_archivo(nombre_arch:string);
var
	arch:file of jugador;
BEGIN
	assign(arch,nombre_arch);
	rewrite(arch);
	close(arch);
END;

procedure guardar_record(nombre_arch:string; r:jugador);
var
	arch:file of jugador;
	r2:jugador;
BEGIN
	assign(arch,nombre_arch);
	reset(arch);
	while not eof(arch)do
		read(arch,r2);
	write(arch,r);
	close(arch);
END;

procedure mostrar_record(nombre_arch:string);
var
	arch:file of jugador;
	y:byte;
	r:jugador;
BEGIN
	y:=3;
	
	textcolor(white);
	gotoxy(3,y);write('Nombre: ');gotoxy(65,y);write('Puntos ');
	y:=y+2;
	textcolor(darkgray);
	
	assign(arch,nombre_arch);
	reset(arch);
	while not eof(arch) do
	begin
		read(arch,r);
		gotoxy(3,y);write(r.nombre);
		gotoxy(65,y);write(r.puntos);
		y:=y+1;
	end;
	close(arch);
END;
END.

