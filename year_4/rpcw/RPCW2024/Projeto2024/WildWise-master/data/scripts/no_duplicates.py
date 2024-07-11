file_path = "./all_animals.txt"
def main():
    linhas = []
    with open(file_path, 'r') as src_file:
        lines = src_file.readlines()

    no_duplicates = list(set(lines))

    result = ""
    for line in no_duplicates:
        result += line
    print(result)
main()