import json
import toml
import glob
import grammar
import sys

def compare(text1, text2, showdif=False):  
  if text1 != text2:
    if showdif:
      for i in range(len(text1)):
          if text1[i] != text2[i]:
              print("Linha " + str(i+1) + " não coincide com o esperado.")
              print("------------------------")
              print("Esperado:\n" + text2)
              print("Obtido:\n" + text1)
              break
    return False
  else:
    return True

def main():
    failed = []
    args = sys.argv
    if len(args) == 2:
      toml_input = args[1]
      load_toml = toml.load(toml_input,_dict=dict)
      expected_json = json.dumps(load_toml,indent=2, default=str)

      parsing_result , given = grammar.convert(toml_input)

      if compare(given,expected_json,showdif=True):
        print("Sucesso!")
      else:
        print("Falha no ficheiro de teste ", toml_input)
    else:
      # INVALID
      invalid_tests = []

      dir_path = r'./tests/invalid/**/*.toml'
      for file_path in glob.glob(dir_path, recursive=True):
          invalid_tests.append(file_path)

      total_invalid_tests = len(invalid_tests)

      print(f"Testando {total_invalid_tests} exemplos inválidos de ficheiros TOML...")

      correct_invalid = 0
      for test in invalid_tests:
        parsing_result , given = grammar.convert(test)

        if parsing_result == False:
          correct_invalid += 1
        else:
          failed.append(test)

      if correct_invalid == total_invalid_tests:
        print(f"Todos os {total_invalid_tests} casos inválidos foram corretamente identificados como inválidos.")
      else:
        print(f"Apenas {correct_invalid} de {total_invalid_tests} casos inválidos foram corretamente identificados como inválidos.")


      # TESTING VALID
      valid_test_inputs = []
      passed_tests = 0

      dir_path = r'./tests/valid/**/*.toml'
      for file_path in glob.glob(dir_path, recursive=True):
          valid_test_inputs.append(file_path)

      total_valid_tests = len(valid_test_inputs)
      toml_lib_errors = 0

      print(f"Testando {total_valid_tests} exemplos válidos de ficheiros TOML...")
      

      for toml_input in valid_test_inputs:
        try:
          load_toml = toml.load(toml_input,_dict=dict)
          expected_json = json.dumps(load_toml,indent=2, default=str)

          parsing_result , given = grammar.convert(toml_input)

          if compare(given,expected_json,showdif=False):
            passed_tests += 1
          else:
            print("Falha no ficheiro de teste ", toml_input)
            print("========================")
            failed.append(toml_input)
        except:
          toml_lib_errors += 1
          pass

      print("SUMÁRIO:")
      print("Total de testes feitos:", total_valid_tests - toml_lib_errors + total_invalid_tests)
      print(f"Identificou {correct_invalid} de {total_invalid_tests} casos inválidos.")
      print(f"Identificou {passed_tests} de {total_valid_tests - toml_lib_errors} casos válidos.")
      print("========================")

      show_failed = input("Mostrar testes falhados? (y/n)")

      if show_failed in ['y','yes']:
        for path in failed:
          print(path)

if __name__ == "__main__":
    main()