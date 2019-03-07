Why use <span>Make</span>?
==========================

Inevitably, over the course of a project one finds themselves updating data and scripts many times. Some scripts depend upon other scripts, and updating any of them, or the underlying data, requires re-executing all scripts in order. One could make a <span>bash</span> script to do this, but <span>Make</span> offers several advantages over a home-cooked <span>bash</span> script. First, <span>Make</span> allows you to specify dependencies among your files which can expedite re-execution. An example of a dependency structure is: script x depends upon data y. When one runs <span>Make</span> it will search specified files, find any that updated, and execute everything that depends on those files. When you have a large project, with a complex dependency structure, this could provide large speed gains over <span>bash</span>. In this document, I will provide an example of how to use <span>Make</span> to sync updates in ones R scripts or data to a LaTeX manuscript.

Setting up a Makefile for your project will take a few minutes, but this time investment will be repaid on any but the simplest of projects.

A brief history of <span>Make</span> 
-------------------------------------

According to the all-knowing Wikipedia, <span>Make</span> was invented by Stuart Feldman at Bell labs way back in 1976. Here is a quote from Feldman regarding the genesis of the program (swiped from Wikipedia; give them $5 this year):

> Make originated with a visit from Steve Johnson (author of yacc, etc.), storming into my office, cursing the Fates that had caused him to waste a morning debugging a correct program (bug had been fixed, file hadn’t been compiled, cc \*.o was therefore unaffected). As I had spent a part of the previous evening coping with the same disaster on a project I was working on, the idea of a tool to solve it came up. It began with an elaborate idea of a dependency analyzer, boiled down to something much simpler, and turned into Make that weekend. Use of tools that were still wet was part of the culture. Makefiles were text files, not magically encoded binaries, because that was the Unix ethos: printable, debuggable, understandable stuff.
>
> –Stuart Feldman, The Art of Unix Programming, Eric S. Raymond 2003

Since the 70s <span>Make</span> has come standard with <span>Unix</span> distributions. It is often used to compile software and update parts of software that rely on things that have changed. Thus, you can just compile the necessary parts of complicated software (like an operating system) without recompiling the whole thing and wasting time.

The tutorial
============

### Prerequisites

You will need to have <span>git</span>, <span>R</span>, a <span>TeX</span> distribution with LaTeX, and <span>Make</span> installed. On an Apple computer you can install <span>Make</span> with the developer tools (to figure out how to do this Google “installing Xcode tools mac”). To install <span>Make</span> on Windows see this page for a place to start, <http://stat545.com/automation02_windows.html>.

If you wish to render pdfs from LaTeX files outside of <span>Overleaf</span> then you will want to also install <span>pdfTeX</span> (or something similar). If you are on an Apple, then you can install <span>mactex</span>, which will come with <span>pdflatex</span>. Note, that you may need to add the <span>TeX</span> library to your path to make <span>pdfTeX</span> easily executable. You can add this line to your path: “/Library/TeX/texbin”. For Windows, my understanding is that a pdf conversion tool should come with most <span>TeX</span> distributions. Alternatively, you can do all rendering in <span>Overleaf</span>.

Second, you will need to link your local project folder (such as an <span>R</span> project) to a <span>git</span> repository. It makes sense to use a remote repository, so your work will be backed up and you can easily access it from other computers or share the repository with collaborators. At the time of writing, both <span>Github</span> and <span>Bitbucket</span> offered free private repositories. Third, if you use <span>Overleaf</span>, then you will need to link your <span>Overleaf</span> project to the aforementioned repository.

For information on how to do all this, see the excellent tutorial created by Jessica Rick (<https://github.com/jessicarick/resources>)

### How <span>Make</span> works

When one runs <span>Make</span> it looks for a “Makefile” that includes instructions for how <span>Make</span> should run. Specifically, a Makefile will include dependency structures and commands that define the build order for a project. For example, a Makefile could say script X depends on script Y and data Z, if Z changes then re-execute Y and then re-execute X.

Inside a Makefile are a series of commands, called “rules”, following this structure:

target: dependencies  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; instructions

where “target” is a file in your project, such as a manuscript; “dependencies” are the scripts, data, etc. that the target depends upon (e.g. the figures and results that go into your manuscript); and, “instructions” are things that must be done to the dependencies in order to successfully get the output that the target uses.

Importantly, the instructions line must be indented with a tab, if you use spaces your Makefile will fail with an error.

For this tutorial, we will use a project with the following dependency structure: a LaTeX manuscript that relies on a figure and some results from two <span>R</span> scripts, which, in turn, rely on a single csv data file. We also want to use <span>git</span> as a version control system for all the files in our project, and sync any local changes with a remote repository. In particular, we want to send our LaTeX manuscript to a remote repo so that we can pull it into <span>Overleaf</span> and use all its handy features. *Note, if changes are made in Overleaf then those changes must be “pulled” to the local repository to see them. It is simplest to start every work session by pulling changes from the remote repository, so you stay synced up. If you want to take your work in a new direction, then learn about making “branches” in <span>git</span>. If you don’t understand what I am talking about read Jessi’s tutorial, linked above, and read a bit aboug <span>git</span>.*

The repository at <https://github.com/JHarrisonEcoEvo/Reproducible_workflow_tutorial> emulates the project structure verbally defined above. Clone this repository and use it to practice! The file “main.tex” will be our example manuscript (with figures, tables, and code). This also functions as a simple LaTeX template that one could use for scientific manuscripts. There are some tips and tricks in this file, and a justification for using LaTeX, so it is worth a scan. There are also two R scripts in the example folder, a directory holding the data, a directory holding the results, this pdf, and of course a Makefile.

### Example code

Navigate to the cloned example directory and open the Makefile (use <span>less</span> or a text editor). It should look like this (with a few additions not shown here):

manuscript.pdf: main.tex linearModel.R scatterplot.R ./data/testdata.csv  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pdflatex -jobname=manuscript main.tex  

main.tex: linearModel.R scatterplot.R  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rscript linearModel.R  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rscript scatterplot.R  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latex main.tex  

linearModel.R: data/testdata.csv  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rscript linearModel.R  

scatterplot.R: data/testdata.csv  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rscript scatterplot.R  

To reiterate, the use of a tab to indent the instruction line following each dependency chain is crucial. Also, the “:” after the target file is critical as well.

To break this code down, we are saying:

1.  Our manuscript.pdf depends upon main.tex, which is our LaTeX file, two R scripts and some data. If any of these change, then we will need to rebuild manuscript.pdf. If <span>Make</span> sees that the dependencies have been updated, it will next look for how to build these dependencies. This is why the order of rules matters.

2.  main.tex depends upon the two R scripts and some data. When any of these change we should run them and rebuild main.tex

3.  scatterplot.R, which is a script that makes a scatterplot, depends upon some data. We should rerun it if the data are updated.

4.  linearModel.R, which is a script that runs a linear model and outputs the results as a table. As before, if the data change then the script should be rerun.

Underneath each dependency structure is an instruction line for what to do if any of the dependencies have changed. <span>Make</span> sense?

As mentioned, the order of rules matter. One should place the most important target, with the most dependencies, first. For more, see <https://www.gnu.org/software/make/manual/html_node/Rules.html>

*Importantly, linearModel.R outputs the results of a linear model into LaTeX format using <span>xtable</span>, which is a super handy R package that translates matrix-like objects into table format. Read the script for an example of how to do this. It is very useful! Never input data into a table by hand again, saves on errors and time.*

Note, you can put all sorts of <span>bash</span> commands into the instruction lines. If you do need to change directories, then you must put the call to cd on the same line, using the line extension command, the backslash (\\). For instance, one could do this to change into the directory R before running a script,

target: dependency  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cd R;\\  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rscript myprogram.R  

Note, this is just an example, in this case it would make more sense to just put the whole relative path to the script in the call to <span>Rscript</span> (i.e. Rscript ./R/myprogram.R"

### Adding <span>git</span> to our Makefile

Lets say we want to commit and push any changes to any file whenever we build. NOTE: this may not be ideal for many reasons, including 1.) one normally does not want to commit every single change, however small; 2.) the easiest way to auto commit and push is to use a standard commit message, which is not helpful at all when looking through version history. That said, I often edit work locally, then need to push it to <span>Overleaf</span> and the convenience of doing this automatically in the Makefile trumps the very real concerns I note above. For important script commits, or data commits, it is wise to provide a more detailed commit message!

Caveats aside, one way to call <span>git</span> as needed is to make a variable in the Makefile. A variable can save quite a bit of typing (and of course you could get quite creative with variables, if desired).

We can augment our original Makefile, thus:

send\_overleaf=git commit -m “auto commit from make” $^ $@;git push  

manuscript.pdf: main.tex linearModel.R scatterplot.R ./data/testdata.csv  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pdflatex -jobname=manuscript main.tex  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${send\_overleaf}  

main.tex: linearModel.R scatterplot.R  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rscript linearModel.R  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rscript scatterplot.R  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; latex main.tex  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${send\_overleaf}   

linearModel.R: ./data/testdata.csv  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rscript linearModel.R  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${send\_overleaf}  

scatterplot.R: ./data/testdata.csv  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rscript scatterplot.R  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${send\_overleaf}  

Note that we assign a variable, called “send\_overleaf”, to perform git commit and git push for us. To call the variable we prefix it with $ and wrap it in either brackets or parantheses. The part of the code that says $^ is an automatic variable that stands for all the dependent files. The $@ is an automatic variable that stands for the target. So we are saying we want to commit and push all the dependent and target files. Lots of other automatic variables exist. See Karl Broman’s example (<https://kbroman.org/minimal_make/> for more.

*Tip: patterns can be used in <span>Make</span> as well. For instance, you could use wildcards to select all files ending in csv or fastq. See Karl Broman’s example for more.*

### How to run <span>Make</span>

Once you have a Makefile in place that works, all one has to do to run it is navigate to the directory with the file and type “make” on the command line. That is it! The Makefile will execute and any targets with dependencies that have changed will rebuild.

### More than you will ever want to know

For bonus points check out the behemoth <span>Make</span> documentation (<https://www.gnu.org/software/make/manual/make.html>). One can probably find all sorts of time saving tricks within, however keep in mind that simple Makefiles are easy to glance at and understand. Even for collaborators that don’t use <span>Make</span>, they can probably figure out what is going on. If one adds too much to a Makefile, then it could become a bit onerous to interpret. Interpretability is better than code compactness.

Also, if you wish to push your project to overleaf directly from a local repository you can see how to set that up here: <https://www.overleaf.com/learn/how-to/How_do_I_push_a_new_project_to_Overleaf_via_git%3F>

First, click on the Menu and go to “git”, click it and copy the address to the Overleaf project. Then navigate to the local repo you want to push to Overleaf. Type the following commands (substitute your link for “your link”).

git remote add overleaf “yourlink”  
git checkout master  
git pull overleaf master –allow-unrelated-histories  
If you want to remove the stuff in your Overleaf project then use:  
git revert –mainline 1 HEAD  
git push overleaf master  

If you wanted to push your local repo to both overleaf and your master repo at the same time you could add something like this to your makefile (substitute as appropriate):  

send\_master=git commit -m “auto commit from make” $^ $@;git push overleaf master  

manuscript.pdf: main.Rtex  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pdflatex -jobname=manuscript main.Rtex  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${send\_overleaf}  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${send\_master}  

