from re import sub, match
if match("M\-13\.0\.Mathematica", window.get_active_class()):
    keyboard.send_keys('<f1>')
else:
    import unicodeit

    try:
        text = clipboard.get_selection()
    except Exception:
        keyboard.send_keys("<f1>")
        print('no selection')
        exit()
    try:
        old = clipboard.get_clipboard()
    except Exception:
        old = -1

    textpp = text
    textpp = sub(r'\\f([a-zA-Z])(?![a-zA-Z])', r'\\mathfrak{\1}', textpp)
    textpp = sub(r'\\bb([a-zA-Z])(?![a-zA-Z])', r'\\mathbb{\1}', textpp)
    textpp = sub(r'\\bf([a-zA-Z])(?![a-zA-Z])', r'\\mathbf{\1}', textpp)
    textpp = sub(r'\\c([a-zA-Z])(?![a-zA-Z])', r'\\mathcal{\1}', textpp)
    textpp = sub(r'\\in(?![a-zA-Z])', '∊', textpp)
    textpp = sub(r'\\dots(?![a-zA-Z])', '...', textpp)
    textpp = sub(r'__([\\\\a-zA-Z0-9{}]*)', r'_{\1}', textpp)
    textpp = textpp.replace('!=', r'\neq') \
        .replace('<=', r'\leq') \
        .replace('>=', r'\geq') \
        .replace('>>', r'\gg') \
        .replace('<<', r'\ll') \
        .replace('^-1', '^{-1}') \
        .replace('=>', r'\Rightarrow') \
        .replace('_*', r'⁎') \
        .replace(r'\star', '★') \
        .replace(r'\smile', '⌣') \
        .replace(r'\langle', '⟨') \
        .replace(r'\<', '⟨') \
        .replace(r'\rangle', '⟩') \
        .replace(r'\>', '⟩') \
        .replace(r'\box', '☐') \
        .replace(r'\surj', '↠') \
        .replace(r'\inj', r'\hookrightarrow') \
        .replace(r'\acts', r'\curvearrowright')
    textpp = textpp.replace(r'\frac12', '½') \
        .replace(r'\frac13', '⅓') \
        .replace(r'\frac14', '¼') \
        .replace(r'\frac23', '⅔') \
        .replace(r'\frac34', '¾') \
        .replace(r'\frac15', '⅕') 
        

    for c in 'CQRZHP':
        textpp = textpp.replace('\\'+c*2, '\\mathbb{' + c + '}')

    new = unicodeit.replace(textpp)
    new = new.replace('\shrug', r'¯\_(ツ)_/¯') \
             .replace(r'^/', 'ᐟ')   
    print(text)
    print(new)
    clipboard.fill_clipboard(new)
    # clipboard.fill_clipboard(window.get_active_class())
    keyboard.send_keys("<shift>+<insert>")

    time.sleep(0.5)
    if old != -1:
        clipboard.fill_clipboard(old)