#lang scribble/doc

Okay, we've made a package and up loaded. But you know what would be lovely?.
Docs! This tutorial is going to start assuming you have a blank file and now clue where to start. By
the end we will have written the documentation for this line-of-best-fit library <show>.

This is racket land, so of course we have a language for documentation! #lang scribble/doc


@(require scribble/manual
          (for-label (only-in typed/racket/base
                              Listof Nonnegative-Flonum Values -> Flonum Real U)
                     (only-in plot/utils renderer2d?)
                     bestfit)
          scribble/examples)

@; start here

In this language everything, by default, is text! And this builds as text! :D <setup>

And blank lines start new paragraphs. But of course, documentation need more than text. Everything
here is in "at-expression" syntax. Using the @"@" sign lets us switch between text and code. As an example
@"@" followed by an open paren lets us write normal racket code:

@(define the-url "http://mathworld.wolfram.com/LeastSquaresFitting.html")

There is also a special syntax for calling functions. For example, to insert a hyperlink:

@(define the-link @hyperlink[the-url]{@bold{Least Squares Fitting}})

Both the []s and {} are optional. If neither are provided its an identifier reference.

The @"@" also lets us switch back from racket mode to scribble mode @;add the define

And of course there are comments:

@; is a a line comment!
@;{is a block comment!}

We can also insert a section title:

@; generally think about this as some code followed by more docs
@; TODO examples via formatting (section titles, bold, etc)
@; can leave any part out. But @ident is just a variable ref not a function call.
@; @ident[] is call with no args.


@;{}

Now lets add a title to our documentation:

@title{Bestfit: Lines of Best Fit} @; walk through the syntax more.

Aaaannd title isn't bound. General rule of thumb, if what you want isn't bound, its probably provided by
scribble/manual.

@;add scribble/manual require. "if you don' know where what you want lives, its probably in scribble/manual

We should also add author information:

@author[(author+email "Spencer Florence" "spencer@florence.io")]

@; Talk more about syntax!

the next part of our documentation is this line that says what module is being documented. We add that
with the defmodule macro.

@defmodule[bestfit]

Bestfit is a library for calculating lines of best fit using @|the-link|.

Oh no!, i want a period after the-link, but then its part of the identifier! use pipes.

Now lets start by documenting one of the functions in the library. We do that with defproc

@; this comes later
@(define bestfit-eval
   (let ()
     (define e (make-base-eval))
     (e '(require racket))
     (e '(require bestfit))
     (e '(require plot/pict))
     (e '(require math/flonum))
     e))

@; since this is a typed/racket library ill use types instead of contracts
@defproc[(graph/linear [xs (Listof Nonnegative-Flonum)]
                       [ys (Listof Nonnegative-Flonum)]
                       @; Optional argurments are done with a third part that specifies the default value
                       [errors (U #f (Listof Flonum)) #f]) @;OPTIONAL ARGS
         (Values renderer2d? renderer2d? renderer2d?)]{
<setup> But if we render this nothing we don't get that lovely cross linking! We need to tell scribble where to
get the crosslinks. We do this by requiring what we need For Label.
                                                       
@;talk about @racket, binding (linear-fit, rendered2d, xs), and _scores.
Uses @racket[linear-fit] to generate three @racket[renderer2d?]s: A plot of the points given by @racket[xs]
and @racket[ys], a plot of the function of best fit, and error bars generated. The error bars are generated from @racket[error], which
is the percentage error on each y coordinate.

Next is deftogether! We have a lot of similar functions, so...

Examples are generated. We give expressions and they are run when documentation is built to generate those
repl interactions. First we need to require scribble/example. Next we need an evaluator:


 @(examples
   #:eval bestfit-eval
   (define (3x^2 x) (* 3.0 (expt x 2.0)))
   ;(: apply-error : Nonnegative-Flonum -> Nonnegative-Flonum)
   (define (add-error y) (+ y (* y (/ (- (random 4) 2) 10.0))))
   (define exact (function 3x^2 #:label "exact" #:color "blue"))
   (define-values (pts fit _)
     (graph/power (build-list 10 (compose fl add1))
                  (build-list 10 (compose 3x^2 fl add1))))
   (plot (list exact fit pts))
   (define-values (pts fit err)
     (graph/power (build-list 10 (compose fl add1))
                  (build-list 10 (compose add-error 3x^2 fl add1))
                  (build-list 10 (const 0.2))))
   (plot (list exact fit pts err)))


 @; code examples in racketblock (codeblock for non-sexp lang)
@; make-log-based-eval
@; talk about defthing and the other stuff

}

@; if we want these bound we have to import them for-label!
@; label is just "its availble for documentation"
@;(for-label typed/racket plot-bestfit)
@;{
 (for-label (only-in typed/racket/base
 Listof Nonnegative-Flonum Values -> Flonum Real U)
 (only-in plot/utils renderer2d?)
 bestfit)}
@; xs, ys, and error bound

@; TODO deftogether
@; examples (use scribble/example not scribble/eval)
