text = clipboard.get_selection()
import os
os.system(f'notify-send.sh --expire-time=1000 --force-expire "{text}"')

keyboard.send_keys('<ctrl>+<shift>+<left>')

keyboard.send_keys('<ctrl>+<shift>+<left>')


try:
    text = clipboard.get_selection()
except Exception:
    print('no selection')
    text = ''
    exit()
    
if text.endswith('Carlos Esparza'):
    new = ' Sanchez'
else:
    new = 'Carlos Esparza'
    
old = clipboard.get_clipboard()+'XXX'
clipboard.fill_clipboard(text + new)
time.sleep(.05)
    
keyboard.send_keys('<shift>+<insert>')
time.sleep(.1)
clipboard.fill_clipboard(old)
