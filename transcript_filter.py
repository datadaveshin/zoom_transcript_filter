#! /usr/bin/env python

import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("filename", help="File to parse")
    args = parser.parse_args()

    with open(args.filename, "r") as f:
        for line in f:
            print(line.strip())

def hello():
    pass

if __name__ == "__main__":
    main()
