import sonidos.*
import juego.*
import enemigos.*

class Proyectil {
  var property position

  method image() = "bala.png"
  method avanzar(){
    // 1. Revisa si justo se metió un enemigo en su celda antes de avanzar
		if (not self.verificarImpacto()) {
			position = position.right(1)
			if (position.x() >= game.width()) {
				self.eliminar()
			} else {
				self.verificarImpacto()
			}
		}
	}

    method verificarImpacto() {
		const enemigosEnCelda = game.getObjectsIn(position).filter({ obj =>
			generadorEnemigos.esEnemigoActivo(obj)}) //filtro para no considerar el fondo del tablero como enemigo
		if (not enemigosEnCelda.isEmpty()) {
			enemigosEnCelda.first().recibirImpacto()
			self.eliminar()
			return true
		}
		return false
	}

    method disparar() {
        game.addVisual(self)
        const tickName = "mover_proyectil_" + self.identity().toString()
        game.onTick(100, tickName, { self.avanzar() })
    }


    method eliminar() {
        if (game.allVisuals().contains(self)) {
            game.removeVisual(self)
            game.removeTickEvent("mover_proyectil_" + self.identity().toString())
        }
    }
}

