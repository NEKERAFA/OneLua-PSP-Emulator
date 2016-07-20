while true do
	buttons.read()
	
	if buttons.held.up then screen.print(10, 10, "Presionado arriba") end
	if buttons.held.down then screen.print(10, 10, "Presionado abajo") end
	if buttons.held.left then screen.print(10, 10, "Presionado izquierda") end
	if buttons.held.right then screen.print(10, 10, "Presionado derecha") end
	
	if buttons.held.cross then screen.print(10, 10, "Presionado equis") end
	if buttons.held.triangle then screen.print(10, 10, "Presionado triángulo") end
	if buttons.held.circle then screen.print(10, 10, "Presionado circulo") end
	if buttons.held.square then screen.print(10, 10, "Presionado cuadrado") end
	
	screen.flip()
end