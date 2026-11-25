import enemigos.*
import tablero.*
import personajes.*
import sonidos.*
import armas.*

object juego {
	var property vidas = 3
	const corazones = []
	var property puntos = 0
	var property highScore = 0
	var modoInfinitoActivo = false
	const tableroInicial = new Tablero(position=game.at(0,0), image= "zonooticos_inicio.gif")
	const tableroMenu = new Tablero(position=game.at(0,0), image= "pantalla_menu.png")
	const tableroEscenario = new Tablero(position=game.at(0,0), image= "escenario.jpg")
	const tableroGameOver = new Tablero(position=game.at(0, 0), image="pantalla_game_over.jpg")
	const tableroWin = new Tablero(position=game.at(0, 0), image="pantalla_win.gif")
	const tableroInstrucciones = new Tablero(position=game.at(0, 0), image="pantalla_instrucciones.jpg")

    method configurar() {
		game.cellSize(96)
		game.height(6)
		game.width(12)

	}
	//ES LO PRIMERO QUE SE EJECUTA
    method iniciarJuego() { 

        self.configurar()
		self.pantallaInicial()
        game.start()
		
	}
    method pantallaInicial() {
		musicaDeInicio.iniciar()
		keyboard.enter().onPressDo{ self.pantallaMenu()}
		game.addVisual(tableroInicial)
    }
	method pantallaMenu() {
	  	keyboard.enter().onPressDo{ 
			musicaDeInicio.sacarMusica()
			self.iniciar()
		}
		keyboard.space().onPressDo{ self.pantallaInstrucciones()}
		game.addVisual(tableroMenu)
	}

    method pantallaInstrucciones() {
		keyboard.x().onPressDo{ game.removeVisual(tableroInstrucciones)}
		keyboard.enter().onPressDo{ 
			musicaDeInicio.sacarMusica()
			self.iniciar()
		}
		game.addVisual(tableroInstrucciones)
	}

	method dibujarVidas() {
		corazones.clear()
		(0 .. vidas - 1).forEach({ i =>
			const corazon = new Tablero(position = game.at(i, game.height() - 1), image = "corazon.png")
			corazones.add(corazon)
			game.addVisual(corazon)
		})
	}

	method quitarCorazon() {
		if (not corazones.isEmpty()) {
			const ultimo = corazones.last()
			game.removeVisual(ultimo)
			corazones.remove(ultimo)
		}
	}

	method perderVida() {
		vidas = vidas - 1
		self.quitarCorazon()
		if (vidas <= 0) {
			self.gameOver()
		}
	}

	method sumarPuntos(cantidad) {
        puntos = puntos + cantidad
		if (puntos > highScore) {
            highScore = puntos
        }
		if (puntos >= 30000 and !modoInfinitoActivo) {
			self.youWin()
		}
    }
	
	method iniciar() {
		game.clear()
		generadorEnemigos.terminarSpawneo()
		game.addVisual(tableroEscenario)
		game.addVisual(hud)
		musicaDeJuego.iniciar()
		modoInfinitoActivo = false
		vidas = 3
		puntos = 0
		self.dibujarVidas()
	    game.addVisualCharacter(personaje)
		game.addVisual(hudPuntos)
		keyboard.space().onPressDo({personaje.disparar()})
		generadorEnemigos.iniciarSpawneo()

	}
	
    method gameOver() {
		game.clear()
		musicaDeJuego.sacarMusica()
		musicaGameOver.iniciar()
		generadorEnemigos.terminarSpawneo()
		game.addVisual(tableroGameOver)
		game.addVisual(puntajeFinalGameOver)
		game.addVisual(highScoreGameOver)
		keyboard.r().onPressDo({ 
			musicaGameOver.sacarMusica()
			self.iniciar()
		})
		keyboard.space().onPressDo{
			musicaGameOver.sacarMusica() 
			self.reiniciarJuego()
		}
	}
    method youWin() {
		game.clear()
		musicaDeJuego.sacarMusica()// sacar musica del juego
		musicaWin.iniciar()
		game.addVisual(tableroWin)
		keyboard.space().onPressDo{
			musicaWin.sacarMusica()
			self.pantallaInicial()}
		keyboard.e().onPressDo{
			musicaWin.sacarMusica()
			modoInfinitoActivo = true
			personaje.puedeDisparar(true)
			self.modoInfinito()
		}
		keyboard.r().onPressDo{
			musicaWin.sacarMusica()
			self.iniciar()
		}
	}
    method reiniciarJuego() {
		game.clear()
		musicaDeInicio.iniciar()
		self.pantallaMenu()
		
	} 
	
	method modoInfinito() {
		game.clear()
		generadorEnemigos.terminarSpawneo()
		musicaDeJuego.iniciar()
		game.addVisual(tableroEscenario)
		game.addVisual(hud)
		self.dibujarVidas()
	    game.addVisualCharacter(personaje)
		game.addVisual(hudPuntos)
		keyboard.space().onPressDo({personaje.disparar()})
		generadorEnemigos.iniciarSpawneo()
	}

}
object hudPuntos {
    method position() = game.at(game.width() - 2, game.height() - 1)

    method text() = "puntaje: " + juego.puntos().toString()

    method textColor() = "FFFFFF" 

}

object puntajeFinalGameOver {

    method position() = game.at(4, 3)
    
    method text() = "Puntaje Final: " + juego.puntos().toString()
    method textColor() = "FFFFFF"
}

object highScoreGameOver {
    method position() = game.at(7, 3)
    method text() = "RECORD: " + juego.highScore().toString()
    method textColor() = "C70404" 
}

object hud{
	method position() = game.at(0, game.height() - 1)

	method image() = "hud.png"
}