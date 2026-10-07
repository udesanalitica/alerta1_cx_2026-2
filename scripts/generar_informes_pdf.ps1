$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$outputDir = Join-Path $projectRoot "informes"
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

$reports = @(
  @{ Campus = "Todos";       File = "informe-caracterizacion-2026-2-consolidado.pdf" },
  @{ Campus = "Bucaramanga"; File = "informe-caracterizacion-2026-2-bucaramanga.pdf" },
  @{ Campus = "Cucuta";      File = "informe-caracterizacion-2026-2-cucuta.pdf" },
  @{ Campus = "Valledupar";  File = "informe-caracterizacion-2026-2-valledupar.pdf" },
  @{ Campus = "Bogota";      File = "informe-caracterizacion-2026-2-bogota.pdf" }
)

Push-Location $projectRoot
try {
  foreach ($report in $reports) {
    Write-Host "Generando $($report.File)..."
    quarto render informes/InformeCampus.qmd `
      --to pdf `
      -P "campus:$($report.Campus)" `
      --output $report.File

    if ($LASTEXITCODE -ne 0) {
      throw "No fue posible generar $($report.File)."
    }

    $generatedFile = Join-Path $projectRoot $report.File
    $destinationFile = Join-Path $outputDir $report.File
    Move-Item -LiteralPath $generatedFile -Destination $destinationFile -Force
  }
}
finally {
  Pop-Location
}
