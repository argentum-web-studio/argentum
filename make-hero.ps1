param(
  [string]$OutPath = "outputs\argentum-web-studio\assets\hero-dashboard.png"
)

Add-Type -AssemblyName System.Drawing

$width = 1280
$height = 820
$bitmap = New-Object System.Drawing.Bitmap $width, $height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

function ColorFromHex([string]$hex) {
  return [System.Drawing.ColorTranslator]::FromHtml($hex)
}

function New-RoundRect([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = $r * 2
  $path.AddArc($x, $y, $d, $d, 180, 90)
  $path.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $path.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
  $path.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $path.CloseFigure()
  return $path
}

function Fill-RoundRect([float]$x, [float]$y, [float]$w, [float]$h, [float]$r, [string]$color) {
  $brush = New-Object System.Drawing.SolidBrush (ColorFromHex $color)
  $path = New-RoundRect $x $y $w $h $r
  $graphics.FillPath($brush, $path)
  $path.Dispose()
  $brush.Dispose()
}

function Draw-RoundRect([float]$x, [float]$y, [float]$w, [float]$h, [float]$r, [string]$color, [float]$lineWidth = 2) {
  $pen = New-Object System.Drawing.Pen (ColorFromHex $color), $lineWidth
  $path = New-RoundRect $x $y $w $h $r
  $graphics.DrawPath($pen, $path)
  $path.Dispose()
  $pen.Dispose()
}

function Draw-Text([string]$text, [float]$x, [float]$y, [float]$size, [string]$color, [string]$weight = "Regular") {
  $style = [System.Drawing.FontStyle]::Regular
  if ($weight -eq "Bold") {
    $style = [System.Drawing.FontStyle]::Bold
  }
  $font = New-Object System.Drawing.Font "Segoe UI", $size, $style, [System.Drawing.GraphicsUnit]::Pixel
  $brush = New-Object System.Drawing.SolidBrush (ColorFromHex $color)
  $graphics.DrawString($text, $font, $brush, $x, $y)
  $font.Dispose()
  $brush.Dispose()
}

$background = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  (New-Object System.Drawing.Rectangle 0, 0, $width, $height),
  (ColorFromHex "#f6f2ea"),
  (ColorFromHex "#dce8e4"),
  [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$graphics.FillRectangle($background, 0, 0, $width, $height)
$background.Dispose()

Fill-RoundRect 88 92 1104 642 28 "#111118"
Fill-RoundRect 110 112 1060 598 22 "#f8f7f4"
Fill-RoundRect 110 112 1060 74 22 "#111118"
Fill-RoundRect 110 150 1060 36 0 "#111118"

Fill-RoundRect 144 139 94 16 8 "#d9b86c"
Fill-RoundRect 970 139 42 16 8 "#393947"
Fill-RoundRect 1028 139 42 16 8 "#393947"
Fill-RoundRect 1088 134 58 26 13 "#7857ee"

Fill-RoundRect 148 226 216 22 6 "#111118"
Fill-RoundRect 148 270 176 10 5 "#d9d7f2"
Fill-RoundRect 148 294 246 10 5 "#d9d7f2"
Fill-RoundRect 148 320 136 34 8 "#7857ee"
Fill-RoundRect 148 400 260 188 16 "#ece8df"
Draw-RoundRect 148 400 260 188 16 "#ded8ca" 2
Draw-Text "Argentum" 178 432 34 "#111118" "Bold"
Draw-Text "strony i sklepy" 180 486 20 "#6d6c78" "Regular"
Fill-RoundRect 178 532 132 18 9 "#75c7b7"

Fill-RoundRect 454 218 552 238 18 "#ebe7dd"
Fill-RoundRect 494 254 132 160 12 "#fbfaf6"
Fill-RoundRect 668 254 132 160 12 "#fbfaf6"
Fill-RoundRect 842 254 132 160 12 "#fbfaf6"
Fill-RoundRect 530 286 62 62 31 "#7857ee"
Fill-RoundRect 704 286 62 62 31 "#d9b86c"
Fill-RoundRect 878 286 62 62 31 "#2e2e37"
Fill-RoundRect 520 376 82 10 5 "#6d6c78"
Fill-RoundRect 694 376 82 10 5 "#6d6c78"
Fill-RoundRect 868 376 82 10 5 "#6d6c78"
Fill-RoundRect 520 400 112 10 5 "#cfcbe8"
Fill-RoundRect 694 400 112 10 5 "#cfcbe8"
Fill-RoundRect 868 400 112 10 5 "#cfcbe8"

Fill-RoundRect 700 492 344 56 12 "#111118"
Fill-RoundRect 724 512 116 10 5 "#c7d6d4"
Fill-RoundRect 902 504 80 26 13 "#d9b86c"

Fill-RoundRect 454 506 184 118 16 "#fbfaf6"
Fill-RoundRect 486 536 86 12 6 "#75c7b7"
Fill-RoundRect 486 566 120 10 5 "#d9d7f2"
Fill-RoundRect 486 590 92 10 5 "#d9d7f2"

Fill-RoundRect 672 586 374 38 10 "#7857ee"
Draw-Text "Nowy projekt gotowy do startu" 704 592 20 "#ffffff" "Bold"

Fill-RoundRect 142 670 996 18 9 "#ded8ca"
Fill-RoundRect 142 670 612 18 9 "#75c7b7"

$graphics.Dispose()
$resolved = Resolve-Path -Path "."
$target = Join-Path $resolved $OutPath
$directory = Split-Path $target -Parent
if (!(Test-Path $directory)) {
  New-Item -ItemType Directory -Force -Path $directory | Out-Null
}
$bitmap.Save($target, [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()
