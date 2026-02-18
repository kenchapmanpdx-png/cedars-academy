Add-Type -AssemblyName System.Drawing

$src = 'C:\Users\kenny\OneDrive\Documents\Websites\Cedar\www.cedarsacademyofmakeup.com-1771302859481\Logo.png'
$dst = 'C:\Users\kenny\.gemini\antigravity\scratch\cedars_academy\assets\images\Logo-white.png'

$bmp = New-Object System.Drawing.Bitmap($src)
$out = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

for ($y = 0; $y -lt $bmp.Height; $y++) {
    for ($x = 0; $x -lt $bmp.Width; $x++) {
        $px = $bmp.GetPixel($x, $y)
        $r = [int]$px.R
        $g = [int]$px.G
        $b = [int]$px.B
        $a = [int]$px.A

        # White/near-white background -> transparent
        if ($r -gt 230 -and $g -gt 230 -and $b -gt 230) {
            $out.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
        # Red pixels (red channel dominant) -> keep as-is
        elseif ($r -gt 150 -and $g -lt 100 -and $b -lt 100) {
            $out.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($a, $r, $g, $b))
        }
        # All other dark pixels (black, gray) -> white
        else {
            $brightness = ($r + $g + $b) / 3
            $alpha = [Math]::Min(255, [int]((255 - $brightness) * 2.0))
            if ($alpha -lt 20) { $alpha = 0 }
            $out.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($alpha, 255, 255, 255))
        }
    }
}

$out.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$out.Dispose()
Write-Host "Done - saved to $dst"
