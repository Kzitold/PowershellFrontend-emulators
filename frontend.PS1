$path = split-path -parent $MyInvocation.MyCommand.Definition
cd $path

#-------
$roms = "$path\..."
$bios = "$path\..."
#-------

$emu = (split-path $MyInvocation.MyCommand.Definition -Leaf).replace(".PS1", ".exe")
$list = (dir $roms).name

# Filter by extension
# $list = (dir $roms | where {$_.extension -eq ".zip"}).name

$line = 0
$end = 25

$max = $list.Length

if ($max -lt $end) {
$end = $max}
$bg = $Host.UI.RawUI.BackgroundColor

$start = {

if ($line -eq $max) {
$line = 0}

if ($line -eq -1) {
$line = $max - 1}

Clear-Host
$rep = $list | select -first 1 -skip ($line)

$Host.UI.RawUI.BackgroundColor = "DarkGray"
($list.replace("$rep", "-> $rep") | select -first 1 -skip ($line))

$Host.UI.RawUI.BackgroundColor = $bg
($list | select -first ($end - 1) -skip ($line + 1))

if (([int]$max) - ([int]$line) -lt $end) {
$list | select -first ($end - ($max -$line))}
$num = $host.UI.RawUI.ReadKey()

if ($num.VirtualKeyCode -eq 32) {
exit}

if ($num.VirtualKeyCode -eq 38) {
$line = ([int]$line) - 1}

if ($num.VirtualKeyCode -eq 40) {
$line = ([int]$line) + 1}

if ($num.VirtualKeyCode -eq 9) {
Clear-Host
& "$path\$emu"
exit}

if ($num.VirtualKeyCode -eq 13) {
Clear-Host
Get-Variable rep
& "$path\$emu" "$roms\$rep"
exit}

&$start
}
&$start
