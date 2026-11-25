import juego.*
import sonidos.*

class Enemigo {
	var property position

	method image()
	method velocidad()
	method puntos()

	method nombreTick() = "mover_enemigo_" + self.identity().toString()

	method aparecer() {
		game.addVisual(self)
		game.onTick(self.velocidad(), self.nombreTick(), { self.avanzar() })
	}

	method avanzar() {
		position = position.left(1)
		if (position.x() < 0) {
			juego.perderVida()
			self.eliminar()
		}
	}

	method recibirImpacto() {
		self.morir()
	}

	method morir() {
		juego.sumarPuntos(self.puntos())
		zombiesMuerto.play()
		self.eliminar()
	}

	method eliminar() {
		if (game.allVisuals().contains(self)) {
			game.removeVisual(self)
			game.removeTickEvent(self.nombreTick())
			generadorEnemigos.quitarEnemigo(self)
		}
	}
}

class Zombie inherits Enemigo {
	override method image() = "zombie.png"
	override method velocidad() = 1000
	override method puntos() = 250
}

class ZombieRapido inherits Enemigo {
	override method image() = "esqueleto.png"
	override method velocidad() = 450
	override method puntos() = 500
}

class ZombieResistente inherits Enemigo {
	var vida = 2

	override method image() = "zombie_gordo.png"
	override method velocidad() = 1500
	override method puntos() = 1000

	override method recibirImpacto() {
		vida = vida - 1
		if (vida <= 0) {
			self.morir()
		}if (vida == 1) {
			daño.play()
		}
	}
}

object generadorEnemigos {
	var activo = false
	const enemigosVivos = []

	method esEnemigoActivo(enemigo) = enemigosVivos.contains(enemigo)

	method tiempoEntreSpawns() {
		const reduccion = (juego.puntos() / 1000).truncate(0) * 200
		return (2500 - reduccion).max(700)
	}
	method maxEnemigos() = (4 + (juego.puntos() / 2500).truncate(0)).min(12)

	method registrarEnemigo(enemigo) {
		enemigosVivos.add(enemigo)
	}

	method quitarEnemigo(enemigo) {
		enemigosVivos.remove(enemigo)
	}

	method fabricasDisponibles() {
		const puntos = juego.puntos()
		if (puntos < 1000) {
			return [
				{ pos => new Zombie(position = pos) }
			]
		} else if (puntos < 3000) {
			return [
				{ pos => new Zombie(position = pos) },
				{ pos => new Zombie(position = pos) },
				{ pos => new ZombieRapido(position = pos) }
			]
		} else {
			return [
				{ pos => new Zombie(position = pos) },
				{ pos => new ZombieRapido(position = pos) },
				{ pos => new ZombieResistente(position = pos) }
			]
		}
	}

	method generar() {
		if (activo) {
			if (enemigosVivos.size() < self.maxEnemigos()) {
				const fila = 0.randomUpTo(game.height() - 1).truncate(0)
				const posicion = game.at(game.width() - 1, fila)
				const enemigo = self.fabricasDisponibles().anyOne().apply(posicion)
				self.registrarEnemigo(enemigo)
				enemigo.aparecer()
			}
			game.schedule(self.tiempoEntreSpawns(), { self.generar() })
		}
	}

	method iniciarSpawneo() {
		if (not activo) {
			activo = true
			enemigosVivos.clear()
			game.schedule(1200, { self.generar() })
		}
	}

	method terminarSpawneo() {
		activo = false
		enemigosVivos.clear()
	}
}