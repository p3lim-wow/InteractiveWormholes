Set-Location -Path "$PSScriptRoot\.."

If(-Not (Test-Path -Path "libs")){
	New-Item -ItemType Directory -Path libs
}

If(-Not (Test-Path -Path "libs\LibStub")){
	New-Item -ItemType SymbolicLink -Path "libs" -Name LibStub -Value ..\LibStub
} ElseIf(-Not (((Get-Item -Path "libs\LibStub").Attributes.ToString()) -Match "ReparsePoint")){
	Remove-Item -Path "libs\LibStub"
	New-Item -ItemType SymbolicLink -Path "libs" -Name LibStub -Value ..\LibStub
}

If(-Not (Test-Path -Path "libs\CallbackHandler-1.0")){
	New-Item -ItemType SymbolicLink -Path "libs" -Name CallbackHandler-1.0 -Value ..\CallbackHandler-1.0
} ElseIf(-Not (((Get-Item -Path "libs\CallbackHandler-1.0").Attributes.ToString()) -Match "ReparsePoint")){
	Remove-Item -Path "libs\CallbackHandler-1.0"
	New-Item -ItemType SymbolicLink -Path "libs" -Name CallbackHandler-1.0 -Value ..\CallbackHandler-1.0
}

If(-Not (Test-Path -Path "libs\HereBeDragons")){
	New-Item -ItemType SymbolicLink -Path "libs" -Name HereBeDragons -Value ..\HereBeDragons
} ElseIf(-Not (((Get-Item -Path "libs\HereBeDragons").Attributes.ToString()) -Match "ReparsePoint")){
	Remove-Item -Path "libs\HereBeDragons"
	New-Item -ItemType SymbolicLink -Path "libs" -Name HereBeDragons -Value ..\HereBeDragons
}

If(-Not (Test-Path -Path "libs\LibBabble-SubZone-3.0")){
	New-Item -ItemType SymbolicLink -Path "libs" -Name LibBabble-SubZone-3.0 -Value ..\LibBabble-SubZone-3.0
} ElseIf(-Not (((Get-Item -Path "libs\LibBabble-SubZone-3.0").Attributes.ToString()) -Match "ReparsePoint")){
	Remove-Item -Path "libs\LibBabble-SubZone-3.0"
	New-Item -ItemType SymbolicLink -Path "libs" -Name LibBabble-SubZone-3.0 -Value ..\LibBabble-SubZone-3.0
}
