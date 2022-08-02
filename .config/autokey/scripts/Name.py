last = store.get_value('last')
try:
    old = clipboard.get_clipboard()
except Exception:
    old = None
    
if time.time() - last > 0.4:
    clipboard.fill_clipboard('Carlos Esparza')
    store.set_value('last', time.time())
else:
    clipboard.fill_clipboard(' Sanchez')
    store.set_value('last', 0)
    
keyboard.send_keys("<shift>+<insert>")
time.sleep(.2)
if old is not None:
    clipboard.fill_clipboard(old)

