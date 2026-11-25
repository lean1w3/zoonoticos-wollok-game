object daño{
	method play() {
		game.sound("daño.mp3").play()
	}
}
object sonidoDisparos {

	method play() {
		game.sound("disparo.mp3").play()
	}

}
object zombiesMuerto {

	method play() {
		game.sound("eliminado.mp3").play()
	}

}

object explosion {// si va a haber explosiones

	method play() {
		game.sound("misca.mp3").play()
	}

}

object musicaDeInicio {
	const musicaFondo = game.sound("musica_inicio.mp3")

	
	method iniciar() {
		if (musicaFondo.paused()){musicaFondo.resume()}
		else{
		musicaFondo.shouldLoop(true)
		musicaFondo.volume(0.3)
		game.schedule(500, { musicaFondo.play()})}
	}

	method sacarMusica() {
		musicaFondo.pause()
	}

	method reiniciar() {
		musicaFondo.resume()
	}
}

object musicaDeJuego {

	const musicaFondo = game.sound("juego.mp3")


	method iniciar() {
		if (musicaFondo.paused()){musicaFondo.resume()}
		else{
		musicaFondo.shouldLoop(true)
		musicaFondo.volume(0.3)
		game.schedule(500, { musicaFondo.play()})}
	}

	method sacarMusica() {
		musicaFondo.pause()
	}

	method reiniciar() {
		musicaFondo.resume()
	}

}
object musicaWin {

	const musicaFondo = game.sound("musica_win.mp3")

	method iniciar() {
		if (musicaFondo.paused()){musicaFondo.resume()}
		else{
		musicaFondo.shouldLoop(true)
		musicaFondo.volume(0.3)
		game.schedule(500, { musicaFondo.play()})}
	}

	method sacarMusica() {
		musicaFondo.pause()
	}

	method reiniciar() {
		musicaFondo.resume()
	}

}

object musicaGameOver {

	const musicaFondo = game.sound("musica_gameOver.mp3")


	method iniciar() {
		if (musicaFondo.paused()){musicaFondo.resume()}
		else{
		musicaFondo.shouldLoop(true)
		musicaFondo.volume(0.3)
		game.schedule(500, { musicaFondo.play()})}
	}

	method sacarMusica() {
		musicaFondo.pause()
	}

	method reiniciar() {
		musicaFondo.resume()
	}

}
