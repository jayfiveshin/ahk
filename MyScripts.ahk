; Shortcut for typing exit app command for AHK

/*

The following are disabled for now.

:*:ep::
  SendInput, #Del::ExitApp
Return

; Open Notepad++
#n::Run, Notepad++

*/

; Simple Test to see if the script is running.
#q::
  MsgBox, The script it active!
Return

; Exit this application using Windows Key + Delete button
#Del::
  MsgBox, MyScript.exe will be closed after this message.
  ExitApp
Return

; This is what I"m currently working on.
^i::
  SendInput ^h ; Open Search & Replace window
  id := WinExist("A") ; Grab the ID of the active window.
  SendInput !g ; Set to Regex mode

  ; Remove all resource keys pertaining to translations.
  SearchAndReplace("{Raw}\s?(meta:)?resourcekey=""\w+""\s?","{Del}")

  ; Match all items that do not contain the following opening and closing tags: DetailSection, Field, GridPanel, GridSection, StageContainer and delete them.
  SearchAndReplace("{Raw}^((?!<\/?ix:DetailSection(\s.+)?>)(?!<\/?ix:Field(\s.+)?>)(?!<\/?ix:GridPanel(\s.+)?>)(?!<\/?ix:GridSection(\s.+)?>)(?!<\/?ix:StageContainer(\s.+)?>).)*$(\r\n)?","{Del}")

  ; Match all leading characters and delete them.
  SearchAndReplace("{Raw}^\s+","{Del}")

  SendInput !. ; Set to . to match newline

  ; Match all StageContainer open and closing tags, then switch their order.
  SearchAndReplace("{Raw}(<ix:StageContainer.+?>)(.+?)(</ix:StageContainer>)","\3\2\1")

  ; Match all DetailSection open and closing tags, then switch their order.
  SearchAndReplace("{Raw}(<ix:DetailSection.+?>)(.+?)(</ix:DetailSection>)","\3\2\1")

  SendInput !. ; Set to . to no longer match newline

  ; Match all items that do not contain the following opening tags: DetailSection, Field, GridPanel, GridSection, StageContainer and delete them.
  SearchAndReplace("{Raw}^((?!<ix:DetailSection(\s.+)?>)(?!<ix:Field(\s.+)?>)(?!<ix:GridPanel(\s.+)?>)(?!<ix:GridSection(\s.+)?>)(?!<ix:StageContainer(\s.+)?>).)*$(\r\n)?","{Del}")

  ; Match all ix tags and delete them.
  SearchAndReplace("{Raw}(<ix:|<\/ix:|>|\/>)","{Del}")

  ; Match all attributes in a single line and add a delimiter (pipes) after.
  SearchAndReplace("{Raw}(((?<!"")\b\w+(?= ))|(\w+=""[^""]*""))","\1|")

  ; Match all pipes with any number of trailing spaces and remove the trailing spaces.
  SearchAndReplace("{Raw}\| *","|")

  ; Match all pipes followed by a newline/carriage-return and remove the pipes.
  SearchAndReplace("{Raw}\|\r\n","\r\n")

  ; Match all entries where For attribute is not the first, then change the order so it is.
  SearchAndReplace("{Raw}(\w+)\|(.+)\|(For=""[\w.]+""|Entity=""[\w._]+"")","\1|\3|\2")

  ; Match all fields where Caption attribute is not the second, then change the order so it is.
  SearchAndReplace("{Raw}((Field|GridPanel|GridSection)\|(For=""[\w.]+""|Entity=""[\w._]+""))\|(.+)\|(Caption="".*?"")","\1|\5|\4")

  ; Match all fields where Caption attribute is not used, then add a place-holder with blank caption.
  SearchAndReplace("{Raw}((Field|GridPanel|GridSection)\|(For=""[\w.]+""|Entity=""[\w._]+""))(\|(?!Caption="".*?"")(?!\|).+|\s|$)","\1|\4")

  ; Match all fields where IsMandatory attribute is not the third, then change the order so it is.
  SearchAndReplace("{Raw}((Field|GridPanel|GridSection)\|(For=""[\w.]+""|Entity=""[\w._]+""))(\|Caption="".*?""|\|)(\|.+)(\|IsMandatory=""\w+"")","\1\4\6\5")

  ; Match all fields where IsMandatory attribute is not used, then add a place-holder with blank caption.
  SearchAndReplace("{Raw}((Field|GridPanel|GridSection)\|(For=""[\w.]+""|Entity=""[\w._]+""))(\|Caption="".*?""|\|)(\|(?!IsMandatory=""\w+"")(?!\|).+|\s|$)","\1\4|\5")

  ; Match all fields where ReadOnly attribute is not the fourth then change the order so it is.
  SearchAndReplace("{Raw}((Field|GridPanel|GridSection)\|(For=""[\w.]+""|Entity=""[\w._]+""))(\|Caption="".*?""|\|)(\|IsMandatory=""\w+""|\|)(\|.+)(\|ReadOnly=""\w+"")","\1\4\5\7\6")

  ; Match all fields where ReadOnly attribute is not used, then add a place-holder with blank caption.
  SearchAndReplace("{Raw}((Field|GridPanel|GridSection)\|(For=""[\w.]+""|Entity=""[\w._]+""))(\|Caption="".*?""|\|)(\|IsMandatory=""\w+""|\|)(\|(?!ReadOnly=""\w+"")(?!\|).+|\s|$)","\1\4\5|\6")

  SendInput !. ; Set to . to match newline

  ; Match all fields and add the StageContainer ID in-front.
  SearchAndReplace("{Raw}(Field|GridPanel|GridSection)(?=.*?StageContainer\|.*?ID=""([^""]+)"")","\2\|\1")

  ; Match all fields and add the DetailSection Title in-front.
  SearchAndReplace("{Raw}(Field|GridPanel)(?=.*?DetailSection\|Title=""([^""]*)"")","\2")

  ; Match all items that contain DetailSection and StageContainer, then delete them.
  SearchAndReplace("{Raw}^(\bDetailSection\b|\bStageContainer\b).*?$(\r\n)?","{Del}")

  SendInput !. ; Set to . to no longer match newline

  ; Match For attributes and strip away everything except for what is contained in the quotes.
  SearchAndReplace("{Raw}\bFor=""([\w.]+)""","\1")

  ; Match Entity attributes and strip away everything except for what is contained in the quotes.
  SearchAndReplace("{Raw}\bEntity=""([\w._]+)""","\1")

  ; Match Caption attributes and strip away everything except for what is contained in the quotes.
  SearchAndReplace("{Raw}\bCaption=""(.*?)""","\1")

  ; Match IsMandatory attributes and strip away everything except for what is contained in the quotes.
  SearchAndReplace("{Raw}\bIsMandatory=""(\w+)""","\1")

  ; Match bReadOnly attributes and strip away everything except for what is contained in the quotes.
  SearchAndReplace("{Raw}\bReadOnly=""(\w+)""","\1")

  ; Match Title attributes and strip away everything except for what is contained in the quotes.
  SearchAndReplace("{Raw}Title=""([\s\w!@#$%^&*()_+.?\/:]+)""","\1")

  ; Match "true" (not enclosed by double quotes) with "Y" (to be pasted to configuration workbook).
  SearchAndReplace("{Raw}(?<!"")true(?!"")","Y")

  ; Match "false" (not enclosed by double quotes) with "N" (to be pasted to configuration workbook).
  SearchAndReplace("{Raw}(?<!"")false(?!"")","N")

  ; Match pipes that come after the first 6 elements, replace with semi-colon. Repeat 10 times to collect all of them.
  Loop, 10
  {
    SearchAndReplace("{Raw}(.*?\|.*?\|.*?\|.*?\|.*?\|.*?\|)(.*?)(\|)","\1\2; ")
  }

  SendInput {Esc}
Return

SearchAndReplace(x,y)
{
  SendInput !f
  SendInput %x%
  SendInput !l
  SendInput %y%
  SendInput !a
  Return
}
