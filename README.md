# LittleScantrexYT

Descargador de videos de YouTube en **MP4** para Windows, con menú en la consola, elección de calidad y preparación automática. Un solo archivo `.bat`: sin instalar Python ni nada más a mano.

## Características

- **Un solo archivo.** Haces doble clic y listo. La primera vez descarga por sí solo lo que necesita.
- **Elige la calidad:**
  - `1` Máxima resolución posible
  - `2` 1080p · `3` 720p · `4` 480p · `5` 360p
  - `R` Cualquier otra resolución que escribas (2160, 1440, 240, 144...)
- **No falla si el video no llega a esa calidad.** Si pides más de lo que el video ofrece, baja la mejor disponible.
- **Compatible.** Prefiere video H.264 y audio AAC para que el MP4 se abra en cualquier reproductor.
- **Descargas seguidas.** Al terminar, la consola se limpia y vuelve el menú con la misma calidad elegida.
- **Carpeta a tu gusto.** Selector de carpeta de Windows (por defecto, `Descargas`).
- **Listas de reproducción.** Si pegas una lista completa, pregunta antes de bajar todos los videos.
- **Actualizable.** Un atajo (`U`) actualiza yt-dlp cuando YouTube cambia algo.

## Requisitos

- Windows 10 o superior
- Conexión a internet (en el primer arranque se descargan unos 250 MB)

## Uso

1. Descarga `LittleScantrexYT.bat` y ponlo en una carpeta propia, por ejemplo en el Escritorio.
2. Haz doble clic. La primera vez prepara las herramientas y tarda unos minutos.
3. Elige la calidad con las teclas `1`-`5` o `R`.
4. Pulsa `D`, pega el link del video y pulsa Enter.

### Menú

| Tecla | Acción |
|-------|--------|
| `1`-`5` | Elegir calidad |
| `R` | Escribir una resolución personalizada |
| `D` | Descargar (pide el link) |
| `C` | Cambiar carpeta de destino |
| `A` | Abrir la carpeta de descargas |
| `U` | Actualizar yt-dlp |
| `S` | Salir |

> Si Windows muestra "Windows protegió tu PC", pulsa **Más información** y luego **Ejecutar de todas formas**. Es el aviso habitual de cualquier `.bat` descargado.

## Cómo funciona

LittleScantrexYT es una interfaz sencilla sobre herramientas de código abierto. En el primer arranque descarga, dentro de una carpeta `herramientas` junto al archivo:

- [yt-dlp](https://github.com/yt-dlp/yt-dlp): hace la descarga.
- [Deno](https://github.com/denoland/deno): YouTube exige hoy un runtime de JavaScript para entregar los formatos.
- [FFmpeg](https://github.com/yt-dlp/FFmpeg-Builds): une video y audio en un MP4.

## Solución de problemas

| Problema | Qué hacer |
|----------|-----------|
| No descarga ningún video | Pulsa `U` para actualizar yt-dlp y prueba con otro video público |
| Falla en el primer arranque | Revisa tu conexión o si el antivirus bloquea la descarga, y vuelve a abrirlo. Se reanuda donde se quedó |
| "No se puede crear la carpeta herramientas" | Mueve el `.bat` al Escritorio o a Documentos |
| Video con restricción de edad, privado o de otro país | yt-dlp no puede descargarlo sin iniciar sesión |
| Los colores salen como símbolos raros | Necesitas Windows 10 o superior; prueba con Windows Terminal |

## Aviso legal

Esta herramienta es solo para **uso personal** con contenido propio, de dominio público o con permiso de su autor. Descargar videos de YouTube puede ir contra sus [Términos de servicio](https://www.youtube.com/t/terms) y el contenido protegido por derechos de autor no es de libre descarga. Cada usuario es responsable del uso que haga de ella. Este proyecto no está afiliado a YouTube ni a Google.

## Créditos

Todo el trabajo pesado lo hacen [yt-dlp](https://github.com/yt-dlp/yt-dlp), [Deno](https://github.com/denoland/deno) y [FFmpeg](https://ffmpeg.org/). Este proyecto solo los envuelve en un menú cómodo.
