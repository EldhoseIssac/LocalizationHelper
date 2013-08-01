LocalizationHelper
==================
<p>This a Mac Appliction Source code which will help to extract strings from Xcode Story board,Genarate 'Localizable.strings' from '.m' files
and can load '.string' files.Then the contents of the file will show in a text field.</p>
<p>To use this you should have diffrent stry board for diffrent languges.</p>
<p>It interaly useses xcode tool "ibtool" and "genstrings" so it should be installed in you system by installing xcode cammand line tools(from xcode>Prefrences>Download>components)</p>
<p>It can use only in a Localized project. with diffrent story boards</p>
<h3>How To Use</h3>
	1.Localize the project to the languges you want.
	2.Open "LocalisationHelper" application in Application folder or run the project in xcode
<p><h5>For Story Board or xib</h5></p>
	3.Click "Load From Story board" and select the storyboard file of root language.(English located in en.lproj folder) and wait for strings to appear in English String.
<p><h5>For .m files in a folder having NSLocalised strings</h5></p>
	3.Click on "load from folder with .m files" and select the folder contains all project files and folder "en.lporj" and wait for strings to appear in English String.
<p><h5>For .m files in a folder having NSLocalised strings</h5></p>
	3.Click on "load from folder with .m files" and select the folder contains all project files and folder "en.lporj" and wait for strings to appear in English String.
<p></p>
	4.Convert all the string in left hand side to that of desired lannguage and paste in right hand side column.(The line number and number of lines should be same).
	5.Select the language folder in "To" combo box.
	6.Click on "Modify For The Output".
	7.Wait to compete execution. And Done
	
	


<p>Thanks for checking this!!</p>
