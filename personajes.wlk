import armas.*
import sonidos.*

object personaje {
	var position = game.origin()
	var property puedeDisparar = true

	method position() = position

	method position(nuevaPosicion) {
		if (nuevaPosicion.x() == 0 and nuevaPosicion.y().between(0, game.height() - 2)) {
			position = nuevaPosicion
        }
	}

	method image() = "abuela.png"

	method disparar() {
        if (puedeDisparar) {
            const proyectil = new Proyectil(position = position.right(1))
            sonidoDisparos.play()
            proyectil.disparar()
            puedeDisparar = false
            game.schedule(300, { puedeDisparar = true })
        }
    }
    
  
}
