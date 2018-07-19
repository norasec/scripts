#!/usr/bin/env python
# -*- coding: utf-8 -*-


import os
import socket
import subprocess
import yara
import magic
import argparse


iplists = [""]
# more: xml, html, mdb, xdb
allow_extensions = [".txt", ".cmd", ".bat", ".ps1",
                    ".sh", ".xls", ".csv", ".ini", ".cfg", ".xem", ".vbs"]
max_filesize = 10485760  # 10mb
vlogin = False
dups = False


def mycallback(data):
    # pprint.pprint(data, depth=10)
    currentmatch = ""
    currentrule = ""
    if data["matches"] is True:
        # print data
        print "\n[*] Found: " + data["rule"]
        for d in data["strings"]:
            if currentmatch != d[2] and currentrule != d[1]:
                print "[*] Matching: {0} in position {1} with rule {2}".format(
                    d[2], str(d[0]), d[1])
                currentmatch = d[2]
                currentrule = d[1]
                # remove dups in same file != positions
            elif dups:
                print "[*] Matching: {0} in position {1} with rule {2}".format(
                    d[2], str(d[0]), d[1])
    yara.CALLBACK_CONTINUE


# analyze and classify files
def analyze_classify_files(filename):
    extension = os.path.splitext(filename)[1]
    # case no extension, but redeable
    if extension == "":
        typefile = f.from_file(filename)
        if len(typefile.split("text")) > 1:
            if vlogin:
                print "[+] No extension, but readable file: " + typefile
            extension = ".txt"
        else:
            pass
    if extension in allow_extensions:
        if vlogin:
            print "[+] Analyzing... " + filename
        filesize = os.path.getsize(filename)
        # check filesize
        if filesize == 0 and vlogin:
            print "[-] File is empty" + filename + "\n"
        elif filesize < max_filesize:
            matches = rules.match(filename, callback=mycallback)
            if matches:
                print "[+] Found in: " + filename + "\n"
        else:
            print "[-] File is too big" + filename + "\n"


# recursive search
def search_dirs_and_files(directory):
    try:
        if vlogin:
            print "[+] Recurso de Red: " + directory
        dirs = os.listdir(directory)
        for d in dirs:
            newdir = directory + "\\" + d
            if os.path.isfile(newdir):
                if vlogin:
                    print "[+] File: " + newdir
                analyze_classify_files(newdir)
            else:
                if vlogin:
                    print "[+] Directory: " + newdir
                search_dirs_and_files(newdir)
    except OSError as e:
        print "[-] Error: " + str(e)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Spider for SMB shared resources")
    parser.add_argument("-v", "--verbose", action="store_true", dest="verbose",
                        default=False, help="print verbose logging")
    parser.add_argument("-d", "--dups", action="store_true", dest="dups",
                        default=False, help="show dups matching rules")
    parser.add_argument("-ms", "--maxsize", dest="maxsize", metavar="<size>",
                        default=max_filesize, help="select the maximum filesize to spider")
    parser.add_argument('-i', '--infile', help="IP's/hostnames infile",
                        dest="infile", metavar="<file>",
                        default=iplists, type=argparse.FileType('r'))

    args = parser.parse_args()
    if args.verbose:
        vlogin = True
    if args.dups:
        dups = True
    if args.infile != iplists:
        iplists = args.infile.read().split("\n")

    f = magic.Magic(magic_file="magic")
    # yara_compiles_and_save
    rules = yara.compile("yara_rules")
    rules.save('my_compiled_rules')
    # start
    print "\n[+] Starting smb spidering \n"
    # search by ip
    for ip in iplists:
        # resolve domain
        domain = socket.gethostbyaddr(ip)[0].split(".")[0]
        print "[+] Searching in: " + domain + "\n"
        # resolve shared
        # for cygwin
        # proc = subprocess.Popen("net view \\" + domain, stdout=subprocess.PIPE, shell=True)
        # for win cmd or powershell
        proc = subprocess.Popen("net view \\\\" + domain,
                                stdout=subprocess.PIPE, shell=True)
        (out, err) = proc.communicate()
        # print out
        locations = []
        # building shared
        for x in out.split("\r\n"):
            if len(x.split("Disk")) > 1:
                location = x.split("Disk")[0].replace(" ", "")
                locations.append("\\\\" + domain + "\\" + location)
        # start recursive search
        for l in locations:
            search_dirs_and_files(l)
