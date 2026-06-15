Add-Type -AssemblyName System.Drawing

$ROOT = $PSScriptRoot

function New-IconPng {
  param([int]$Size, [string]$OutFile)

  $bmp = New-Object System.Drawing.Bitmap($Size, $Size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g   = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode   = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.Clear([System.Drawing.Color]::Transparent)

  # Rounded rect (teal)
  $rx     = [int]($Size * 0.225)
  $color  = [System.Drawing.Color]::FromArgb(255, 31, 138, 112)   # #1f8a70
  $brush  = New-Object System.Drawing.SolidBrush($color)
  $path   = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d      = $rx * 2
  $path.AddArc(0,          0,          $d, $d, 180, 90)
  $path.AddArc($Size - $d, 0,          $d, $d, 270, 90)
  $path.AddArc($Size - $d, $Size - $d, $d, $d,   0, 90)
  $path.AddArc(0,          $Size - $d, $d, $d,  90, 90)
  $path.CloseFigure()
  $g.FillPath($brush, $path)

  # "DH" text
  $fs       = [float]($Size * 0.42)
  $font     = New-Object System.Drawing.Font("Arial", $fs, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $white    = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
  $sf       = New-Object System.Drawing.StringFormat
  $sf.Alignment          = [System.Drawing.StringAlignment]::Center
  $sf.LineAlignment      = [System.Drawing.StringAlignment]::Center
  $rect     = New-Object System.Drawing.RectangleF(0, 0, $Size, $Size)
  $g.DrawString("DH", $font, $white, $rect, $sf)

  $g.Dispose()
  $bmp.Save((Join-Path $ROOT $OutFile), [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Host "OK  $OutFile"
}

function New-OgImage {
  $W = 1200; $H = 630
  $bmp = New-Object System.Drawing.Bitmap($W, $H, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g   = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

  # Dark navy background
  $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 14, 22, 52))
  $g.FillRectangle($bgBrush, 0, 0, $W, $H)

  # Teal icon box (152×152 centred at top)
  $boxW = 152; $boxH = 152; $boxX = ($W - $boxW) / 2; $boxY = 100
  $rx   = 34
  $teal = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 31, 138, 112))
  $bp   = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d    = $rx * 2
  $bp.AddArc($boxX,              $boxY,              $d, $d, 180, 90)
  $bp.AddArc($boxX + $boxW - $d, $boxY,              $d, $d, 270, 90)
  $bp.AddArc($boxX + $boxW - $d, $boxY + $boxH - $d, $d, $d,   0, 90)
  $bp.AddArc($boxX,              $boxY + $boxH - $d, $d, $d,  90, 90)
  $bp.CloseFigure()
  $g.FillPath($teal, $bp)

  # "DH" inside box
  $fontIcon = New-Object System.Drawing.Font("Arial", 64, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $white    = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
  $sfC      = New-Object System.Drawing.StringFormat
  $sfC.Alignment     = [System.Drawing.StringAlignment]::Center
  $sfC.LineAlignment = [System.Drawing.StringAlignment]::Center
  $iconRect = New-Object System.Drawing.RectangleF($boxX, $boxY, $boxW, $boxH)
  $g.DrawString("DH", $fontIcon, $white, $iconRect, $sfC)

  # Name
  $fontName = New-Object System.Drawing.Font("Arial", 54, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $nameRect = New-Object System.Drawing.RectangleF(100, 295, 1000, 70)
  $g.DrawString("Daniel Havlíček", $fontName, $white, $nameRect, $sfC)

  # Subtitle
  $fontSub  = New-Object System.Drawing.Font("Arial", 26, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $subColor = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 255, 255, 255))
  $subRect  = New-Object System.Drawing.RectangleF(100, 380, 1000, 40)
  $g.DrawString("Tvorba webů Praha od 3 000 Kč", $fontSub, $subColor, $subRect, $sfC)

  # Divider line
  $linePen  = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 31, 138, 112), 2)
  $g.DrawLine($linePen, 540, 445, 660, 445)

  # URL
  $fontUrl  = New-Object System.Drawing.Font("Arial", 20, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $urlColor = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(90, 255, 255, 255))
  $urlRect  = New-Object System.Drawing.RectangleF(100, 462, 1000, 32)
  $g.DrawString("danielhavlicek.cz", $fontUrl, $urlColor, $urlRect, $sfC)

  $g.Dispose()
  $bmp.Save((Join-Path $ROOT "og-image.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Host "OK  og-image.png  (1200x630)"
}

New-IconPng -Size 16  -OutFile "favicon-16x16.png"
New-IconPng -Size 32  -OutFile "favicon-32x32.png"
New-IconPng -Size 180 -OutFile "apple-touch-icon.png"
New-OgImage

Write-Host "`nDone. 4 files written to project root."
