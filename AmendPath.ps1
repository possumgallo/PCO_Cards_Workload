# amending batch file

[string]$RunContents = get-content($PSScriptRoot + '\Run.bat')
$RunContents = $RunContents.substring(1,$RunContents.length-25)

do 
{
    write-host "Is the following path to Python.exe correct?:"
    write-host ("`t " + $RunContents)

    $response = read-host "Please indicate (y/n)"
    $path = $null

    do  
    {
        switch ($response)
        {

            # if y - continues as normal
            "y" {$path = $RunContents}
            
            # if n - steps to find correct directory to include
            "n" {
                    write-host "To find the correct location, please follow these steps:
        1. Click/press windows button bottom left
        2. Type ""%APPDATA%"" - press Enter
        3. Click on ""AppData"" in filepath (should be in ""Roaming"" folder by default)
        4. Open the ""Local"" > ""Programs"" > ""Python"" > ""Python38-32""
    ""Python38-32"" is the folder you want - copy that path and paste it here.

    NOTE: if this folder isn't visible you'll need to review the README.docx file.`n"

                

                    $path = read-host "Please indicate new path"
                }

            # if a value other than y or n is selected, loop
            default {$response = read-host "Please choose a correct response (y/n)"}
        }

    # while path has no value, loop
    } while ($path -eq $null)


    # appending python.exe to directory
    if ($path.Substring($path.Length-10) -ne "python.exe") {$path = $path + "\python.exe"}

    # initializing bool - checking if python.exe is visible at the path specified
    [bool]$check = test-path $path -pathtype leaf

    # if it couldn't find python.exe at the path specified, say so and restart
    if (!$check) {write-host "This file path is invalid - could not find ""python.exe"" - please try again.`n`n---`n"}

} while (!$check)

# if response was n then replace Run.bat with the correct path, else leave as it is

if ($response -eq "n") {
    $newRunLine = '"' + $path + '" "%cd%\script.py" pause'
    set-content -path ($PSScriptRoot + "\Run.bat") -value $newRunLine
    write-host "Successfully amended path - please double click ""Run.bat"" to start process."
} else {
    write-host "Please double click ""Run.bat"" to start the process."
}




