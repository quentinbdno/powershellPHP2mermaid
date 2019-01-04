# Ce script permet de présenter sous la forme d'un diagrame les relations entre les fichiers PHP. 
# Le résultat est à parser par Mermaid pour obtenir le graphique.

$repository = Get-ChildItem ""
$destination = ""
Set-Content -Path $destination -Value "graph LR;"

function listRepo ($repo,$dest,[int]$tour=0) {
    Write-host On est à l''itération $tour
    ForEach($i in $repo){
        If($i.GetType().fullname -eq "System.IO.DirectoryInfo"){
            $newrepo = Get-ChildItem $i.FullName
            $tour++
            listRepo $newrepo $dest $tour
        }
        If($i.Name -match '.php'){
            $lines = Select-String -Path $i.FullName -Pattern '(require).*'  -AllMatches |Foreach {$_.Line}
            foreach($line in $lines){
                # il faut triater les chaines semblables les plus longues dans un premier temps
                If($line -match "require_once "){
                    $match = [regex]::matches($line,'(?<=require_once ).*').value
                    Write-Host $match
                    $text = "    "+$i.fullName+"--require-once-->"+$match
                    Add-Content -Path $dest -Value $text
                }
                ElseIf($line -match "require_once"){
                    $match = [regex]::matches($line,'(?<=require_once).*').value
                    Write-Host $match
                    $text = "    "+$i.fullName+"--require-once-->"+$match
                    Add-Content -Path $dest -Value $text
                }Elseif($line -match "require "){
                    $match = [regex]::matches($line,'(?<=require ).*').value
                    Write-Host $match.gettype()
                    $text = "    "+$i.fullName+"--require-->"+$match
                    Add-Content -Path $dest -Value $text
               }Else{
                    $match = [regex]::matches($line,'(?<=require).*').value
                    Write-Host $match.gettype()
                    $text = "    "+$i.fullName+"--require-->"+$match
                    Add-Content -Path $dest -Value $text
               }
            }
        }
        #Write-Host $i.GetType()
        # Write-host $i.GetType() $i.Name $i.FullName
    }
}

listRepo $repository $destination 
