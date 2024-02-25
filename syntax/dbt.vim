" dbt jinja + SQL syntax file
" Language: dbt Jinja SQL
" Maintainer: Pedram Navid <pedram@pedramnavid.com>
" Last Change: Feb 25, 2024

if exists("b:current_syntax")
    finish
endif

" Import default SQL syntax
runtime! syntax/sql.vim

syntax case ignore


" Borrowed from lepture/vim-jinja, these are jinja specific
" keywords that are matched withi jinja regions {{ .. }} and
" {% ... %}
syn keyword jinjaStatement contained if else elif endif is not
syn keyword jinjaStatement contained for in recursive endfor
syn keyword jinjaStatement contained raw endraw
syn keyword jinjaStatement contained block endblock extends super scoped
syn keyword jinjaStatement contained macro endmacro call endcall
syn keyword jinjaStatement contained from import as do continue break
syn keyword jinjaStatement contained filter endfilter set endset
syn keyword jinjaStatement contained include ignore missing
syn keyword jinjaStatement contained with without context endwith
syn keyword jinjaStatement contained trans endtrans pluralize
syn keyword jinjaStatement contained autoescape endautoescape

hi def link jinjaStatement Statement

" jinja templete built-in filters
syn keyword jinjaFilter contained abs attr batch capitalize center default
syn keyword jinjaFilter contained dictsort escape filesizeformat first
syn keyword jinjaFilter contained float forceescape format groupby indent
syn keyword jinjaFilter contained int join last length list lower pprint
syn keyword jinjaFilter contained random replace reverse round safe slice
syn keyword jinjaFilter contained sort string striptags sum
syn keyword jinjaFilter contained title trim truncate upper urlize
syn keyword jinjaFilter contained wordcount wordwrap

hi def link jinjaFilter Identifier

" jinja template built-in tests
syn keyword jinjaTest contained callable defined divisibleby escaped
syn keyword jinjaTest contained even iterable lower mapping none number
syn keyword jinjaTest contained odd sameas sequence string undefined upper

hi def link jinjaTest Type

syn keyword jinjaFunction contained range lipsum dict cycler joiner
hi def link jinjaFunction Function

" Keywords to highlight within comments
syn keyword jinjaTodo contained TODO FIXME XXX
syn region jinjaComBlock start="{#" end="#}" contains=jinjaTodo containedin=ALLBUT,@jinjaBlocks

hi def link jinjaTodo Todo
hi def link jinjaComBlock Comment


" ---------------------------
" Additional dbt Jinja syntax
" These are specific to SQL files that have embedded Jinja in them
" ---------------------------

" Common dbt Jinja syntax

" Common dbt functions as well package imported functions, e.g.
" dbt_utils.foo(..)
syn keyword dbtJinjaFunction    ref source config var   containedin=dbtJinjaTemplate
syn match   dbtJinjaFunction    "\v\S+\ze\(\_.{-}\)"      containedin=dbtJinjaTemplate
syn region  dbtJinjaString      matchgroup=Quote start=+"+ end=+"+ skipwhite keepend containedin=dbtJinjaTemplate
syn region  dbtJinjaString      matchgroup=Quote start=+'+ end=+'+ skipwhite keepend containedin=dbtJinjaTemplate
syn match   dbtJinjaOperator    "{{\|}}\|{%\|%}"

hi link     dbtJinjaOperator    Operator
hi link     dbtJinjaFunction    Function
hi link     dbtJinjaString      String

syn cluster dbtJinja           contains=dbtJinjaOperator,dbtJinjaFunction,dbtJinjaString

syn region  dbtJinjaTemplate   start=+{%+ end=+%}+ contains=@dbtJinja,jinjaStatement,jinjaFilter,dbtJinjaTemplate transparent 
syn region  dbtJinjaTemplate   start=+{{+ end=+}}+ contains=@dbtJinja,jinjaStatement,jinjaFilter,dbtJinjaTemplate transparent

" CTE name, attempts to match xxx in > xxx as ( ... )
syn match   dbtJinjaKeyword     "\v\S+\ze\s+as\s+\(\_.{-}\)"
syn keyword dbtJinjaKeyword     this containedin=dbtJinjaTemplate
hi  link    dbtJinjaKeyword     PreProc

let b:current_syntax = "dbt"
