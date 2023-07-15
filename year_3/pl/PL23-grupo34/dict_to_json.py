import re


def is_valid_json_number(value):
    pattern = r'^-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][-+]?\d+)?$'
    return re.match(pattern, value) is not None


def add_aspas(s):
    if s[0] == '"' == s[1]:
        return s
    else:
        return '"' + s + '"'


def add_tab_to_lines(text):
    lines = text.splitlines()
    indented_lines = ['  ' + line for line in lines]
    indented_text = '\n'.join(indented_lines)
    return indented_text


def dict_to_json(dictionary):
    converted_to_text = ""

    if len(dictionary) == 0:
        return "{}"
    for k, v in list(dictionary.items())[:-1]:
        e = parse_elem(v)
        converted_to_text += add_aspas(k) + ": " + e + ",\n"

    k, v = list(dictionary.items())[-1]
    e = parse_elem(v)
    converted_to_text += add_aspas(k) + ": " + e + "\n"
    s = "{\n" + add_tab_to_lines(converted_to_text) + "\n}"
    return s


def parse_elem(element):
    if type(element) is dict:
        s = dict_to_json(element)
        return s
    if type(element) is list:
        lst = ""
        for elem in element[:-1]:
            lst += parse_elem(elem) + ",\n"
        lst += parse_elem(element[-1])
        lst = "[\n" + add_tab_to_lines(lst) + "\n]"
        return lst
    if type(element) is bool:
        if element:
            return "true"
        else:
            return "false"
    if type(element) is None:
        return ""
    if is_valid_json_number(str(element)):
        return str(element)
    else:
        return add_aspas(str(element))