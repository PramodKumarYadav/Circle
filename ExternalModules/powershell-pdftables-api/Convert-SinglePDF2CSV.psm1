
# Reference and credit for this script: https://github.com/pdftables/powershell-pdftables-api 
function Convert-SinglePDF2CSV{
	param (
	  [Parameter(Mandatory=$True,Position=0)]
	  [string]$apikey,
	  
	  [Parameter(Mandatory=$True,Position=1)]
	  [string]$infile,
	  
	  [Parameter(Mandatory=$True,Position=2)]
	  [string]$outdir,
	  
	  [string]$format = "csv" # Default is changed to csv 
	)

	$ErrorActionPreference = 'Stop'

	Add-Type -AssemblyName 'System.Net.Http'

	$url = 'https://pdftables.com/api?format=' + $format + '&key=' + $apikey
	$filename = ($infile.Split("\")[$infile.Split("\").count - 1]).Split(".")[0]
	$outfile = $outdir + "\" + $filename + "." + $format.Split('-')[0]
	
	Write-Host ('Converting "' + $infile + '" to "' + $outfile + '"')

	Try {
	  $client = New-Object System.Net.Http.HttpClient
	  $request = New-Object System.Net.Http.HttpRequestMessage([System.Net.Http.HttpMethod]::Post, $url)
	  
	  $content = New-Object System.Net.Http.MultipartFormDataContent
	  $fileStream = [System.IO.File]::OpenRead($infile)
	  $fileContent = New-Object System.Net.Http.StreamContent($fileStream)
	  $content.Add($fileContent, 'unused', 'unused')

	  $request.Content = $content 
	  $result = $client.SendAsync($request, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).GetAwaiter().GetResult()
	  $stream = $result.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
	  $fileStream = [System.IO.File]::Create($outfile)
	  $stream.CopyTo($fileStream)
	}
	Catch {
	  Write-Error $_
	  exit 1
	}
	Finally {
	  if ($fileContent -ne $null) { $fileContent.Dispose() }
	  if ($fileStream -ne $null) { $fileStream.Dispose() }
	  if ($content -ne $null) { $content.Dispose() }
	  if ($request -ne $null) { $request.Dispose() }
	  if ($client -ne $null) { $client.Dispose() }
	}
}

# Reference and credit for this script: https://github.com/pdftables/powershell-pdftables-api 
function Convert-DirectoryPDF2CSV{
	param (
	  [Parameter(Mandatory=$True,Position=0)]
	  [string]$apikey,

	  [Parameter(Mandatory=$True,Position=1)]
	  [string]$indir,

	  [Parameter(Mandatory=$True,Position=2)]
	  [string]$outdir,

	  [string]$format = "csv" # Default is changed to csv 
	)
  
	$ErrorActionPreference = 'Stop'
	
	Try {
		# Create the outdirectory to store formatted results
		New-Item -ItemType Directory -Force -Path $outsubdir

		# Get all pdf files from input directory, 
		$pdfFiles = Get-ChildItem $indir -Recurse -File -Filter *.pdf 
		foreach($pdf in $pdfFiles){
			Convert-SinglePDF2CSV -apikey $apikey -infile "$pdf" -outdir $outdir -format $format
		}
	}
	Catch {
	  Write-Error $_
	  exit 1
	}
  }