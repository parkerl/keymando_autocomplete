AUTOCOMPLETE
============

"Look behind" autocomplete for almost any Mac OS X app. Great for developers.

__INSTALLATION__

Copy `autocomplete.rb` into your *Keymando* Plugins directory.


__CONFIGURATION__

1. Set your activation sequence (the default is *control + space* - `<Ctrl- >`)

        Autocomplete.map=  "<Alt- >" #Set activation to alt + space

2. Set the list of apps where you want to enable Autocomplete…Mail.app is enabled by default.
    
        Autocomplete.app_list << /Coda/
        Autocomplete.app_list << /Pages/

3. Set a list of "break" charaters that when pressed will accept the current autocompletion and toggle autocomplete.

        Autocomplete.breaks << ";"

    
__USAGE__

In an Autocomplete enabled app, type a word fragment that exists in any text before your current cursor postition. Press `<Ctrl- >` (or your own sequence). Autocomplete will find any words that match the word fragment next to your cursor and fill in the first entry. Press `<Tab>` to replace the word with the next possible match. When Autocomplete runs out of matches it will replace the original fragment. Press any of the following keys to accept the match and end the Autocomplete session. 

    Space,<Return>,.,",",?,-,<Delete>



