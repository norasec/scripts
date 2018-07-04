#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-


import argparse
import sys
import os


# bookmarks path
bookmarks = "C:\\pathto\\exported_bookmarks.html"

# if cywgin or linux
rows, columns = os.popen('stty size', 'r').read().split()
columns = int(columns)

# if windows cmd
# from ctypes import windll, create_string_buffer
# import struct
#         # stdin handle is -10
#         # stdout handle is -11
#         # stderr handle is -12
# h = windll.kernel32.GetStdHandle(-12)
# csbi = create_string_buffer(22)
# res = windll.kernel32.GetConsoleScreenBufferInfo(h, csbi)
# (bufx, bufy, curx, cury, wattr,
# left, top, right, bottom,
# maxx, maxy) = struct.unpack("hhhhHhhhhhh", csbi.raw)
# sizex = right - left + 1
# sizey = bottom - top + 1
# columns = int(sizex)


def build_and_show_full_tree(content):
    tab = "--"
    lvl = 0
    blank = "| "
    visual = ""
    for x in content.split("\n"):
        # blank and tab fix
        tree = blank * (lvl - 1) + "|" + tab
        # lvl up
        if len(x.split("<DL>")) > 1:
            lvl = lvl + 1
        # folder
        elif len(x.split("<DT><H3")) > 1:
            createfolder = x.split("</H3>")[0].split('">')[1]
            visual += tree + "lvl:" + \
                str(lvl) + " mkdir " + createfolder + "\n"
        # classify link
        elif len(x.split("HREF")) > 1:
            extractlink = x.split('HREF=')[1].split('"')[1]
            extracttext = x.split('</A>')[0].split('">')[-1]
            visual += tree + "link " + extractlink + "\n"
            visual += tree + "< description > " + extracttext + "\n"
            if len(extractlink.split("github.com")) > 1:
                visual += tree + "gitclone " + extractlink + "\n"
            elif extractlink.endswith(".pdf"):
                visual += tree + "wget " + extractlink + "\n"
            else:
                pass
        # lvl and folder fix
        elif len(x.split("</DL")) > 1:
            lvl = lvl - 1
            visual += tree + "lvl:" + str(lvl) + " cd.." + "\n"
    return visual


def find_and_return_link_and_tree(visual, link):
    father = ""
    parentstree = ""
    for x in visual.split('\n'):
        # find link in full tree
        if len(x.split('link')) > 1 and len(x.split(link)) > 1:
            # search and fix father (cos folders and links same lvl)
            newparent = parentstree.split('\n')[::-1]
            for y in parentstree.split('\n')[::-1]:
                if y != "" and (len(x.split("--")[0].split('|')) > len(y.split("--")[0].split('|'))):
                    father = y.split('mkdir ')[1]
                    level = y.split('lvl:')[1].split(' mkdir')[0]
                    break
                newparent.pop(0)
            # prints
            print "#" * columns + "\n"
            print '[+] Found link with father folder: ' + father
            print '[+] Found link with parents tree: \n'
            # fix levels
            fixlvl = int(level)
            ordernewparent = []
            # reverse tree
            for n in newparent:
                if len(n.split('lvl:' + str(fixlvl))) > 1:
                    fixlvl = fixlvl - 1
                    ordernewparent.append(n)
            for nn in ordernewparent[::-1]:
                print nn
            # print link
            print x
            # prints
            url = x.split('link ')[1]
            description = visual.split(url)[1].split(
                '\n')[1].split('< description > ')[1]
            print "\n[+] Your URL: " + url
            print "[+] Description: " + description + '\n'
            # update description
        # father and tree
        if len(x.split('mkdir')) > 1:
            # delete when lvl 1 found
            if len(x.split('lvl:1')) > 1:
                parentstree += '\n' + x + '\n'
            else:
                parentstree += x + '\n'
            father = x.split('mkdir ')[1]


def donwload_all(content):
    path = os.getcwd()
    lvl = 0
    for x in content.split("\n"):
        if len(x.split("<DL>")) > 1:
            lvl = lvl + 1
        elif len(x.split("<DT><H3")) > 1:
            createfolder = x.split("</H3>")[0].split('">')[1]
            createfolder = createfolder.replace("/", "-").strip("'")
            if not os.path.exists(path + createfolder):
                os.mkdir(createfolder)
                os.chdir(createfolder)
                print "mkdir " + createfolder
        elif len(x.split("HREF")) > 1:
            extractlink = x.split('HREF=')[1].split('"')[1].strip("'")
            extracttext = x.split('</A>')[0].split('">')[-1]
            extracttext = extracttext.replace("/", "-").strip("'")
            # check if extracttext dir is created
            if not os.path.exists(path + extracttext):
                os.mkdir(extracttext)
                os.chdir(extracttext)
                print "mkdir " + extracttext
                print "cd " + extracttext
                if len(extractlink.split("github.com")) > 1:
                    print "gitclone " + extractlink
                elif extractlink.endswith(".pdf"):
                    print "wget " + extractlink
                else:
                    print "wget -p -k " + extractlink
                os.chdir("..")
                print "cd.."
        elif len(x.split("</DL")) > 1:
            lvl = lvl - 1
            os.chdir("..")
            print "cd.."


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="Downloader, visualizer and finder for your firefox bookmarks")
    parser.add_argument("-d", "--download", action="store_true", dest="download",
                        default=False, help="download all bookmarks in current folder")
    parser.add_argument("-f", "--find", action="store_true", dest="find",
                        default=False, help="if used alone show full bookmarks order by level")
    parser.add_argument("-l", "--link", action="store", dest="link",
                        default="", help='''find link passed as argument,
                        father folder and parents tree (-f mandatory)''')

    args = parser.parse_args()

    if (args.find or args.link) and args.download:
        print "\n[-] Error, cannot use donwload with other flags"
        sys.exit()
    elif not args.find and args.link != "":
        print "\n[-] Error, cannot use search link withoug -f flag"
        sys.exit()

    with open(bookmarks, "r") as infile:
        content = infile.read()
        infile.close()

    # same as v, but retrieve father and tree location if a link is gaven
    if args.find:
        visual = ""
        # return and print full tree
        visual = build_and_show_full_tree(content)
        print visual

    # find link if link given with pather and tree
    if args.find and (args.link != ""):
        if len(visual.split(args.link)) > 1:
            find_and_return_link_and_tree(visual, args.link)
        else:
            print '[-] Error, Link not found'

    # download all
    if args.download:
        while(True):
            print "[*] It will download all your bookmars to the current folder"
            name = raw_input("Are you sure? (Y/N) ")
            if name.lower() == 'y':
                print '\n[+] Starting Download...'
                # download all links classified by github, pdf or office files,
                # normal webs
                donwload_all(content)
                print "[*] Download Finished"
                sys.exit()
            elif name.lower() == 'n':
                print '\n[-] Exit'
                sys.exit()

