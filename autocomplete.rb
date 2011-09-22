class Autocomplete < Plugin
   class << self
      attr_accessor :enabled
      attr_accessor :words
      attr_accessor :original_clipboard
      attr_accessor :map
      attr_accessor :breaks
      attr_accessor :app_list


      def toggle
         @enabled = !@enabled
         
         system (@enabled ? '/usr/local/bin/growlnotify -m "" -a Keymando Autocomplete enabled.' : '/usr/local/bin/growlnotify -m "" -a Keymando Autocomplete disabled.')
         
      end


      def stash_clipboard
         s = IO.popen('pbpaste', 'r+').read
         @original_clipboard = s
      end

      def get_words
         s = IO.popen('pbpaste', 'r+').read
         @words = s.scan(/\w+/).uniq
      end

      def filter_words(filter)
         s = Regexp.escape(filter)
         @words = @words.select do |w|
            w.match(/^#{s}\w*/i)
         end
         @words.delete filter
         @words.sort!
         @words.push filter
      end

      def next_word
         @words.shift if @words
      end

      def enabled?
         @enabled
      end
   end

   def before
      Autocomplete.map = "<Ctrl- >"
      Autocomplete.breaks = [" ","<Return>",".",",","?","-","<Delete>"]
      Autocomplete.app_list = [/Mail/]

   end

   def after
      Autocomplete.app_list.each do |app|
         only app do
            map Autocomplete.map do
               Autocomplete.toggle
               return if ! Autocomplete.enabled?
               Autocomplete.breaks.each do |b|
                  map b do
                     reset if Autocomplete.enabled?
                     send(b)
                  end
               end
               Autocomplete.stash_clipboard
               send('<Alt-Left>')
               send('<Shift-Home>')
               send('<Cmd-c>')
               send('<Right>')
               send('<Alt-Right>')
               send('<Alt-Shift-Left>')
               sleep(0.5)
               Autocomplete.get_words
               send('<Cmd-c>')
               sleep(0.5)
               m = IO.popen('pbpaste', 'r+').read
               Autocomplete.filter_words(m)
               map '<Tab>' do
                  fill
               end
               map "<Right>" do
                  reset
               end

               begin
                  fill
               rescue
                  reset
                  alert('Autocomplete failed')
               ensure
                  IO.popen('pbcopy', 'w').puts Autocomplete.original_clipboard
               end
            end
         end
      end
   end

   def reset
      Autocomplete.toggle if Autocomplete.enabled?
      Autocomplete.words = nil
      Autocomplete.original_clipboard = nil
      send('<Right>')
      map('<Tab>', '<Tab>')
      map("<Right>", "<Right>")
      Autocomplete.breaks.each { |b| map b, b}
   end

   def fill
      @next_word = Autocomplete.next_word
      if (Autocomplete.enabled? && @next_word)
         send(@next_word)
         send('<Alt-Shift-Left>')
      else
         reset
      end
   end


end

