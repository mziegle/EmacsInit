(defun jp/replace-with-hiragana(romanji)
  "Converts a word in romanji into hiragana"
  (interactive "sWord to convert: ")
  (setq hiragana-list
        '(("ka" "か") ("ki" "き") ("ku" "く") ("ke" "け") ("ko" "こ") ("sa" "さ")
          ("shi" "し") ("su" "す") ("se" "せ") ("so" "そ") ("ta" "た")
          ("chi" "ち") ("tsu" "つ") ("te" "て") ("to" "と") ("na" "な")
          ("ni" "に") ("nu" "ぬ") ("ne" "ね") ("no" "の") ("ha" "は") ("hi" "ひ")
          ("fu" "ふ") ("he" "へ") ("ho" "ほ") ("ma" "ま") ("mi" "み") ("mu" "む")
          ("me" "め") ("mo" "も") ("ya" "や") ("yu" "ゆ") ("yo" "よ") ("ra" "ら")
          ("ri" "り") ("ru" "る") ("re" "れ") ("ro" "ろ") ("wa" "わ") ("wo" "を")
          ("ga" "が") ("gi" "ぎ") ("gu" "ぐ") ("ge" "げ") ("go" "ご") ("za" "ざ")
          ("ji" "じ") ("zu" "ず") ("ze" "ぜ") ("zo" "ぞ") ("da" "だ") ("di" "ぢ")
          ("du" "づ") ("de" "で") ("do" "ど") ("ba" "ば") ("bi" "び") ("bu" "ぶ")
          ("be" "べ") ("bo" "ぼ") ("pa" "ぱ") ("pi" "ぴ") ("pu" "ぷ") ("pe" "ぺ")
          ("po" "ぽ") ("kya" "きゃ") ("kyu" "きゅ") ("kyo" "きょ") ("sha" "しゃ")
          ("shu" "しゅ") ("sho" "しょ") ("cha" "ちゃ") ("chu" "ちゅ")
          ("cho" "ちょ") ("nya" "にゃ") ("nyu" "にゅ") ("nyo" "にょ")
          ("hya" "ひゃ") ("hyu" "ひゅ") ("hyo" "ひょ") ("mya" "みゃ")
          ("myu" "みゅ") ("myo" "みょ") ("rya" "りゃ") ("ryu" "りゅ")
          ("ryo" "りょ") ("gya" "ぎゃ") ("gyu" "ぎゅ") ("gyo" "ぎょ")
          ("ja" "じゃ") ("ju" "じゅ") ("jo" "じょ") ("bya" "びゃ") ("byu" "びゅ")
          ("byo" "びょ") ("pya" "ぴゃ") ("pyu" "ぴゅ") ("pyo" "ぴょ") ("n" "ん")
          ("a" "あ") ("i" "い") ("u" "う") ("e" "え") ("o" "お")))

  (dolist (current-hiragana hiragana-list )
    (setq romanji
          (replace-regexp-in-string
           (nth 0 current-hiragana)
           (nth 1 current-hiragana)
           romanji)))
  romanji)
