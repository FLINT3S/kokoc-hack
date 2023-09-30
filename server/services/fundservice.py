import bcrypt as bcrypt

if __name__ == "__main__":
    print(bcrypt.hashpw(str.encode("admin"), bcrypt.gensalt()))