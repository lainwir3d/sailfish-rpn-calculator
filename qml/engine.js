/****************************************************************************************
**
** Copyright (C) 2013 Riccardo Ferrazzo <f.riccardo87@gmail.com>.
** All rights reserved.
**
** This program is based on ubuntu-calculator-app created by:
** Dalius Dobravolskas <dalius@sandbox.lt>
** Riccardo Ferrazzo <f.riccardo87@gmail.com>
**
** This file is part of ScientificCalc Calculator.
** ScientificCalc Calculator is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** ScientificCalc Calculator is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
****************************************************************************************/

.pragma library

// ----------------------------------------
// constants (const keyword is not working)
var MAX_DECIMAL = 13; // Number of maximum decimal positions

var RAD = 0, DEG = 1, GRAD = 2; //Trigonometric functions

var main_stack = Array();
var undo_stack = Array();

for(var i=0;i<20;i++){
    main_stack[i] = '';
    undo_stack[i] = '';
}

// ----------------------------------------
// utils
function stripFloat(number){
    return parseFloat(number.toFixed(MAX_DECIMAL));
}

// ----------------------------------------
// exceptions
function DivisionByZeroError(message){
    this.message = message;
}

DivisionByZeroError.prototype = new Error();

function ParenthesisError(message, missing){
    this.message = message;
    this.missing = missing;
}

ParenthesisError.prototype = new Error();


String.prototype.trunc = String.prototype.trunc ||
      function(n){
          return this.length>n ? this.substr(0,n-1) : this;
      };

String.prototype.truncate =
    function(n){
        var p  = new RegExp("^.{0," + n + "}[\\S]*", 'g');
        var re = this.match(p);
        var l  = re[0].length;
        var re = re[0].replace(/\s$/,'');

        if (l < this.length) return re;
    };

// ----------------------------------------
// Math customizations
Math._sin = Math.sin;
Math._cos = Math.cos;
Math._tan = Math.tan;
Math._asin = Math.asin;
Math._acos = Math.acos;
Math._atan = Math.atan;

Math.sin = function(x, mode){
    switch(mode){
    case undefined:
    case RAD:
        return Math._sin(x);

    case DEG:
        return Math._sin(x * Math.PI / 180);

    case GRAD:
        return Math._sin(x * Math.PI / 200);
    }
}

Math.cos = function(x, mode){
    switch(mode){
    case undefined:
    case RAD:
        return Math._cos(x);

    case DEG:
        return Math._cos(x * Math.PI / 180);

    case GRAD:
        return Math._cos(x * Math.PI / 200);
    }
}

Math.tan = function(x, mode){
    switch(mode){
    case undefined:
    case RAD:
        return Math._tan(x);

    case DEG:
        return Math._tan(x * Math.PI / 180);

    case GRAD:
        return Math._tan(x * Math.PI / 200);
    }
}

Math.asin = function(x, mode){
    switch(mode){
    case undefined:
    case RAD:
        return Math._asin(x);

    case DEG:
        return Math._asin(x * Math.PI / 180);

    case GRAD:
        return Math._asin(x * Math.PI / 200);
    }
}

Math.acos = function(x, mode){
    switch(mode){
    case undefined:
    case RAD:
        return Math._acos(x);

    case DEG:
        return Math._acos(x * Math.PI / 180);

    case GRAD:
        return Math._acos(x * Math.PI / 200);
    }
}

Math.atan = function(x, mode){
    switch(mode){
    case undefined:
    case RAD:
        return Math._atan(x);

    case DEG:
        return Math._atan(x * Math.PI / 180);

    case GRAD:
        return Math._atan(x * Math.PI / 200);
    }
}

Math.log10 = function(x){
    return Math.log(x) / Math.LN10;
}

Math.log2 = function(x){
    return Math.log(x) / Math.LN2;
}

Math.factorial = function(x){
    var cache = [1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800, 479001600, 6227020800, 87178291200, 1307674368000, 20922789888000, 355687428096000, 6402373705728000, 121645100408832000, 2432902008176640000]
    var abs_x = Math.abs(x);
    if(abs_x<=20 && abs_x % 1 === 0){
        var res = (abs_x > 0) ? (abs_x/x)*cache[abs_x] : cache[abs_x];
        return res;
    }

    // Lanczos Approximation of the Gamma Function
    // As described in Numerical Recipes in C (2nd ed. Cambridge University Press, 1992)
    var z = x + 1;
    var p = [1.000000000190015, 76.18009172947146, -86.50532032941677, 24.01409824083091, -1.231739572450155, 1.208650973866179E-3, -5.395239384953E-6];

    var d1 = Math.sqrt(2 * Math.PI) / z;
    var d2 = p[0];

    for (var i = 1; i <= 6; ++i)
        d2 += p[i] / (z + i);

    var d3 = Math.pow((z + 5.5), (z + 0.5));
    var d4 = Math.exp(-(z + 5.5));

    return d1 * d2 * d3 * d4;
}

// ----------------------------------------
// tokens
var T_UNMATCHED = 0,
        T_NUMBER      = 1,  // number
        T_IDENT       = 2,  // ident (constant)
        T_FUNCTION    = 4,  // function
        T_POPEN       = 8,  // (
        T_PCLOSE      = 16, // )
        T_COMMA       = 32, // ,
        T_OPERATOR    = 64, // operator
        T_PLUS        = 65, // +
        T_MINUS       = 66, // -
        T_TIMES       = 67, // *
        T_DIV         = 68, // /
        T_MOD         = 69, // %
        T_POW         = 70, // ^
        T_UNARY_PLUS  = 71, // unary +
        T_UNARY_MINUS = 72, // unary -
        T_FACTORIAL   = 73, // ! factorial function
        T_MODE        = 128;// DEG, RAD or GRAD



// ----------------------------------------
// stack
function Stack() {
    this.index = -1;
}

Stack.prototype = {
    constructor: Stack,

    length: 0,

    push:    Array.prototype.push,
    pop:     Array.prototype.pop,
    shift:   Array.prototype.shift,
    unshift: Array.prototype.unshift,

    first: function first() {
        // this is actualy faster than checking "this.length" everytime.
        // is looks like common jitter are able to optimize
        // array out-of-bounds checks very very well :-)
        return this[0];
    },

    last: function last() {
        // yada yada yada see comment in .first() :-)
        return this[this.length - 1];
    },

    peek: function peek() {
        // yada yada yada see comment in .first() :-)
        return this[this.index + 1];
    },

    next: function next() {
        // yada yada yada see comment in .first() :-)
        return this[++this.index];
    },

    prev: function prev() {
        // yada yada yada see comment in .first() :-)
        return this[--this.index];
    }
}

// ----------------------------------------
// context
function Context() { //function names cannot contain numbers
    this.fnt = {
        '√': Math.sqrt,
        "ln": Math.log,
        "log": Math.log10,
        "sin": Math.sin,
        "cos": Math.cos,
        "tan": Math.tan,
        "asin": Math.asin,
        "acos": Math.acos,
        "atan": Math.atan
    };
    this.cst = {
        'π': Math.PI,
        'E': Math.E
    };
}


// ----------------------------------------
// Get formula texts for visual output
// and engine.
function processInput(prev, visual, engine, type, formula_text, formula_text_for_engine, angularUnit_str) {
    var visual_text = null;
    var engine_text = null;
    var fixed_type = type;

    var angularUnit;

    if(!main_stack){
        console.log("main_stack undefined : defining")
        main_stack = new Stack;
    }

    /*
    if(type !== 'stack'){
        if(engine !== 'undo'){
            console.log("saving stack...");
            undo_stack = main_stack;
            console.log("undo stack : " + undo_stack)
        }
    }
    */

    switch(angularUnit_str){
        case "RAD":
            angularUnit = 0;
            break;
        case "DEG":
            angularUnit = 1;
            break;
        case "GRAD":
            angularUnit = 2;
            break;
    }

    switch (type) {
        case 'number': {
            visual_text = visual;
            engine_text = engine;

            if (prev != null && prev.type == 'real')
                fixed_type = prev.type;
            }
            break;
        case 'real': {
            /*
            if (prev == null || prev.type != 'real') {
                visual_text = visual;
                engine_text = engine;
            }
            */
            visual_text = visual;
            engine_text = engine;
            }
            break;
        case 'const': {
            visual_text = visual;
            engine_text = engine;
            }
            break;
        case 'operation': {
            var args = [];
            var ok = 0;
            var answer;
            var nb_args;
            var args_needed;

            for(nb_args=0;nb_args<20;nb_args++){
                if(main_stack[nb_args] === '') break;
            }

            console.log("nb_args :", nb_args)

            if(formula_text_for_engine !== '') {
                nb_args++;
                args[0] = Number(formula_text_for_engine);
                for(var i=0;i<nb_args;i++){
                    args[i+1] = Number(main_stack[i]);
                }
            }else{
                for(var i=0;i<nb_args;i++){
                    args[i] = Number(main_stack[i]);
                }
            }

            saveStack();

            switch(engine){
                case '+':
                    args_needed = 2;
                    if(nb_args >= args_needed){
                        console.log(args[0], " + ", args[1])
                        answer = args[1] + args[0];
                        ok = 1;
                    }
                    break;
                case '-':
                    args_needed = 2;
                    if(nb_args >= args_needed){
                        answer = args[1] - args[0];
                        ok = 1;
                    }
                    break;
                case '*':
                    args_needed = 2;
                    if(nb_args >= args_needed){
                        answer = args[1] * args[0];
                        ok = 1;
                    }
                    break;
                case '/':
                    args_needed = 2;
                    if(nb_args >= args_needed){
                        answer = args[1] / args[0];
                        ok = 1;
                    }
                    break;
                case 'neg':
                    args_needed = 1;
                    if(nb_args >= args_needed){
                        answer = args[0] * -1;
                        ok = 1;
                    }
                    break;
                case '^':
                    args_needed = 2;
                    if(nb_args >= args_needed){
                        answer = Math.pow(args[1], args[0]);
                        ok = 1;
                    }
                    break;
                case 'x^2':
                    args_needed = 1;
                    if(nb_args >= args_needed){
                        answer = Math.pow(args[0], 2);
                        ok = 1;
                    }
                    break;
                case '10^x':
                    args_needed = 1;
                    if(nb_args >= args_needed){
                        answer = Math.pow(10, args[0]);
                        ok = 1;
                    }
                    break;
                case 'Σ+':
                    args_needed = nb_args;
                    console.log("arg needed : " + args_needed)
                    if(nb_args >= 2){
                        answer = args[nb_args-1];
                        for(var j=nb_args-2;j>=0;j--){
                            console.log("answer (" + answer + ") += "+args[j] + " + "+args[j-1]);
                            answer += args[j];
                        }
                        ok = 1;
                    }
                    break;
                case 'Σ-':
                    args_needed = nb_args;
                    console.log("arg needed : " + args_needed)
                    if(nb_args >= 2){
                        answer = args[nb_args-1];
                        for(var j=nb_args-2;j>=0;j--){
                            console.log("answer (" + answer + ") += "+args[j] + " - "+args[j-1]);
                            answer -= args[j];
                        }
                        ok = 1;
                    }
                    break;

            }

        }
            break;
        case 'function': {
            var args = [];
            var ok = 0;
            var answer;
            var nb_args;
            var args_needed;

            for(nb_args=0;nb_args<20;nb_args++){
                if(main_stack[nb_args] === '') break;
            }

            console.log("nb_args :", nb_args)

            if(formula_text_for_engine !== '') {
                nb_args++;
                args[0] = Number(formula_text_for_engine);
                for(var i=0;i<nb_args;i++){
                    args[i+1] = Number(main_stack[i]);
                }
            }else{
                for(var i=0;i<nb_args;i++){
                    args[i] = Number(main_stack[i]);
                }
            }

            saveStack();

            switch(engine){
                case 'cos':
                    args_needed = 1;
                    if(nb_args >= args_needed){

                        answer = Math.cos(args[0], angularUnit);
                        ok = 1;
                    }
                    break;
                case 'acos':
                    args_needed = 1;
                    if(nb_args >= args_needed){

                        answer = Math.acos(args[0], angularUnit);
                        ok = 1;
                    }
                    break;
                case 'sin':
                    args_needed = 1;
                    if(nb_args >= args_needed){

                        answer = Math.sin(args[0], angularUnit);
                        ok = 1;
                    }
                    break;
                case 'asin':
                    args_needed = 1;
                    if(nb_args >= args_needed){

                        answer = Math.asin(args[0], angularUnit);
                        ok = 1;
                    }
                    break;
                case 'tan':
                    args_needed = 1;
                    if(nb_args >= args_needed){

                        answer = Math.tan(args[0], angularUnit);
                        ok = 1;
                    }
                    break;
                case 'atan':
                    args_needed = 1;
                    if(nb_args >= args_needed){

                        answer = Math.atan(args[0], angularUnit);
                        ok = 1;
                    }
                    break;
                case 'sqrt':
                    args_needed = 1;
                    if(nb_args >= args_needed){

                        answer = Math.sqrt(args[0]);
                        ok = 1;
                    }
                    break;
                case 'ln':
                    args_needed = 1;
                    if(nb_args >= args_needed){

                        answer = Math.log(args[0]);
                        ok = 1;
                    }
                    break;
                case 'log':
                    args_needed = 1;
                    if(nb_args >= args_needed){

                        answer = Math.log10(args[0]);
                        ok = 1;
                    }
                    break;
                case 'inv':
                    args_needed = 1;
                    if(nb_args >= args_needed){

                        answer = 1 / args[0];
                        ok = 1;
                    }
                    break;
                case 'e^x':
                    args_needed = 1;
                    if(nb_args >= args_needed){
                        answer = Math.pow(Math.E, args[0]);
                        ok = 1;
                    }
                    break;
            }


        }
            break;
        case 'stack': {


                var args = [];
                var ok = 0;
                var answer;
                var nb_args;
                var args_needed;

                for(nb_args=0;nb_args<20;nb_args++){
                    if(main_stack[nb_args] === '') break;
                }

                console.log("nb_args :", nb_args)

                if(formula_text_for_engine !== '') {
                    nb_args++;
                    args[0] = Number(formula_text_for_engine);
                    for(var i=0;i<nb_args;i++){
                        args[i+1] = Number(main_stack[i]);
                    }
                }else{
                    for(var i=0;i<nb_args;i++){
                        args[i] = Number(main_stack[i]);
                    }
                }


                switch(engine){
                    case 'enter':
                        saveStack();

                        if(formula_text_for_engine !== ''){
                            console.log("pushing ", formula_text_for_engine ," to stack");
                            stackPush(formula_text_for_engine);
                        }else if(main_stack[0] !== ''){
                            console.log("pushing ", main_stack[0] ," to stack");
                            stackPush(main_stack[0]);
                        }

                        formula_text_for_engine = '';
                        formula_text = '';
                        break;
                    case 'swap':
                        saveStack();

                        stackSwap(0,1);
                        break;
                    case 'drop':
                        saveStack();

                        stackPop(1);
                        break;
                    case 'clr':
                        saveStack();

                        stackPop(20);
                        break;
                    case 'undo':
                        console.log("restoring undo stack : " + undo_stack)
                        restoreStack();
                        break;
                    case 'R-':
                        saveStack();
                        var tmp = main_stack[0];
                        for(var j=0;j<nb_args-1;j++){
                            main_stack[j] = main_stack[j+1];
                        }
                        main_stack[nb_args-1] = tmp;
                        break;
                    case 'R+':
                        saveStack();
                        var tmp = main_stack[nb_args-1];
                        for(var j=nb_args-1;j>0;j--){
                            main_stack[j] = main_stack[j-1];
                        }
                        main_stack[0] = tmp;
                        break;
            }
            break;
    }

    }

    if(ok == 1){
        if(formula_text_for_engine !== ''){
            if(args_needed === 1){
                stackPush(String(answer));
            }else{
                stackPop(args_needed-2);
            }
        }else{
            stackPop(args_needed-1);
        }

        formula_text_for_engine = '';
        formula_text = '';
        //main_stack[0] = String(answer.toFixed(4));
        main_stack[0] = String(answer);
        //main_stack[0] = main_stack[0].truncate(5);
        console.log(main_stack[0]);

    }


    console.log("undo stack : " + undo_stack);
    console.log("main stack : " + main_stack);

    return [visual_text, engine_text, fixed_type, formula_text, formula_text_for_engine];
}


function stackPush(el){
    for(var i=19;i>0;i--){
        main_stack[i] = main_stack[i-1];
    }
    main_stack[0] = el;
}

function stackPop(nb){
    for(var i=0;i<20;i++){
        main_stack[i] = main_stack[i+nb];
    }

    for(var i=19;i>19-nb;i--){
        main_stack[i] = '';
    }
}

function stackSwap(idx_1, idx_2){
    var tmp = main_stack[idx_1];
    main_stack[idx_1] = main_stack[idx_2];
    main_stack[idx_2] = tmp;
}

function stackLength(){
    var count = 0;
    for(var i=0;i<20;i++){
        if(main_stack[i] !== '') count++;
    }
    return count;
}

function saveStack(){
    var count = 0;
    for(var i=0;i<20;i++){
        undo_stack[i] = main_stack[i];
    }
    return count;
}


function restoreStack(){
    var count = 0;
    for(var i=0;i<20;i++){
        main_stack[i] = undo_stack[i];
    }
    return count;
}
