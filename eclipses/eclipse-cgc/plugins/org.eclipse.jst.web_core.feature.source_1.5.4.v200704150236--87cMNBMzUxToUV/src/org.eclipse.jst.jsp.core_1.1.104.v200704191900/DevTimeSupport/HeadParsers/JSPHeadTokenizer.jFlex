/*******************************************************************************
 * Copyright (c) 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
/*nlsXXX*/
package org.eclipse.jst.jsp.core.internal.contenttype;
import java.io.IOException;
import java.io.Reader;

import org.eclipse.wst.xml.core.internal.contenttype.EncodingParserConstants;
import org.eclipse.wst.xml.core.internal.contenttype.XMLHeadTokenizerConstants;





%%

%{




        private boolean hasMore = true;
        private final static int MAX_TO_SCAN = 8000;
        StringBuffer string = new StringBuffer();
        // state stack for easier state handling
        private IntStack fStateStack = new IntStack();
        private String valueText = null;
        private boolean isXHTML;
        private boolean isWML;


        public JSPHeadTokenizer() {
                super();
        }

          public void reset (Reader in) {
                /* the input device */
                zzReader = in;

                /* the current state of the DFA */
                zzState = 0;

                /* the current lexical state */
                zzLexicalState = YYINITIAL;

                /* this buffer contains the current text to be matched and is
                 the source of the yytext() string */
                java.util.Arrays.fill(zzBuffer, (char)0);

                /* the textposition at the last accepting state */
                zzMarkedPos = 0;

                /* the textposition at the last state to be included in yytext */
                zzPushbackPos = 0;

                /* the current text position in the buffer */
                zzCurrentPos = 0;

                /* startRead marks the beginning of the yytext() string in the buffer */
                zzStartRead = 0;

                /**
                 * endRead marks the last character in the buffer, that has been read
                 * from input
                 */
                zzEndRead = 0;

                /* number of newlines encountered up to the start of the matched text */
                //yyline = 0;

                /* the number of characters up to the start of the matched text */
                yychar = 0;

                /**
                 * the number of characters from the last newline up to the start
                 * of the matched text
                 */
                //yycolumn = 0;

                /**
                 * yy_atBOL == true <=> the scanner is currently at the beginning
                 * of a line
                 */
                zzAtBOL = true;

                /* yy_atEOF == true <=> the scanner has returned a value for EOF */
                zzAtEOF = false;

                /* denotes if the user-EOF-code has already been executed */
                zzEOFDone = false;


                fStateStack.clear();

                hasMore = true;
                isXHTML=false;
                isWML=false;


        }


        public final HeadParserToken getNextToken() throws IOException {
                String context = null;
                context = primGetNextToken();
                HeadParserToken result = null;
                if (valueText != null) {
                        result = createToken(context, yychar, valueText);
                        valueText = null;
                } else {
                        result = createToken(context, yychar, yytext());
                }
                return result;
        }

        public final boolean hasMoreTokens() {
                return hasMore && yychar < MAX_TO_SCAN;
        }
        private void pushCurrentState() {
                fStateStack.push(yystate());

        }
 
        private void popState() {
                yybegin(fStateStack.pop());
        }
        private HeadParserToken createToken(String context, int start, String text) {
                return new HeadParserToken(context, start, text);
        }
        
        public boolean isXHTML() {
            return isXHTML;
        }
        public boolean isWML() {
            return isWML;
        }        

%}

%eof{
        hasMore=false;
%eof}

%public
%class JSPHeadTokenizer
%function primGetNextToken
%type String
%char
%unicode
%ignorecase
//%debug
%switch
%buffer 8192


UTF16BE = \xFE\xFF
UTF16LE = \xFF\xFE
UTF83ByteBOM = \xEF\xBB\xBF

// SpaceChar = [\x20\x09]


// [3] S ::= (0x20 | 0x9 | 0xD | 0xA)+
S = [\x20\x09\x0D\x0A]

BeginAttribeValue = {S}* \= {S}*

LineTerminator = \r|\n


%state ST_XMLDecl
%state ST_PAGE_DIRECTIVE
%state QuotedAttributeValue
%state DQ_STRING
%state SQ_STRING
%state UnDelimitedString

%%


<YYINITIAL>
{
         // force to start at beginning of line (^) and at beginning of file (yychar == 0)
        ^ {UTF16BE}           {if (yychar == 0 ) {hasMore = false; return EncodingParserConstants.UTF16BE;}}
        ^ {UTF16LE}           {if (yychar == 0 ) {hasMore = false; return EncodingParserConstants.UTF16LE;}}
        ^ {UTF83ByteBOM}       {if (yychar == 0 ) {hasMore = false; return EncodingParserConstants.UTF83ByteBOM;}}
        
        // force to be started on first line, but we do allow preceeding spaces
        ^ {S}* "<\?xml" {S}+ {if (yychar == 0 ) {yybegin(ST_XMLDecl); return XMLHeadTokenizerConstants.XMLDeclStart;}}


        // following are some simply rules to identify JSP content as "XHTML"
        // see http://www.rfc-editor.org/rfc/rfc3236.txt
        "<!DOCTYPE" {S}* "html" {S}* "PUBLIC" .* "//DTD XHTML"                {isXHTML = true;}
        "<html" {S}* "xmlns" {S}* "=" {S}* (\" | \') "http://www.w3.org/1999/xhtml"     {isXHTML = true;}
         // another case that's part of the "HTML family" is WML 1.0 (WML 2.0 is part of XHTML)
         "<!DOCTYPE" {S}* "wml" {S}* "PUBLIC" .* "//DTD WML"                   {isWML = true;}

        "<%" {S}* "@" {S}* "page" {S}+   {yybegin(ST_PAGE_DIRECTIVE); return JSPHeadTokenizerConstants.PageDirectiveStart;}
        "<jsp:directive.page" {S}+           {yybegin(ST_PAGE_DIRECTIVE); return JSPHeadTokenizerConstants.PageDirectiveStart;}


}

<ST_XMLDecl>
{
        "version" {BeginAttribeValue} {pushCurrentState(); yybegin(QuotedAttributeValue); return XMLHeadTokenizerConstants.XMLDeclVersion;}
        "encoding" {BeginAttribeValue} {pushCurrentState(); yybegin(QuotedAttributeValue); return XMLHeadTokenizerConstants.XMLDelEncoding;}
        // note the "forced end" (via 'hasMore=false') once the end of XML Declaration found
        // This is since non-ascii chars may follow and may cause IOExceptions which would not occur once stream is
        // read with incorrect encoding (such as if platform encoding is in effect until true encoding detected).
        // BUT, the hasMore=false was removed for this JSP case (probably still ok for pure XML) because
        // in a JSP, we must parse past xmlDecl to get at JSP page directive.
        // We'll assume all chars in this area are "readable" as is.
        {S}* "\?>"    {yybegin(YYINITIAL); return XMLHeadTokenizerConstants.XMLDeclEnd;}
}

<ST_PAGE_DIRECTIVE>
{
//  removed 'language' since it really can be handled seperately from encoding, but may add it back later for simple re-use.
        "language"     {BeginAttribeValue} {pushCurrentState(); yybegin(QuotedAttributeValue); return JSPHeadTokenizerConstants.PageLanguage;}
        "contentType" {BeginAttribeValue}  {pushCurrentState(); yybegin(QuotedAttributeValue); return JSPHeadTokenizerConstants.PageContentType;}
        "pageEncoding" {BeginAttribeValue} {pushCurrentState(); yybegin(QuotedAttributeValue); return JSPHeadTokenizerConstants.PageEncoding;}
        // note the "forced end" (via 'hasMore=false') once the end of XML Declaration found
        // This is since non-ascii chars may follow and may cause IOExceptions which would not occur once stream is
        // read in correct encoding.

        // https://w3.opensource.ibm.com/bugzilla/show_bug.cgi?id=4205 demonstrates how we need to keep parsing,
        // even if come to end of one page directive, so hasMore=false was removed from these rules.
        "%>"    { yybegin(YYINITIAL);  return JSPHeadTokenizerConstants.PageDirectiveEnd;}
        "\/>"    { yybegin(YYINITIAL); return JSPHeadTokenizerConstants.PageDirectiveEnd;}
}


<QuotedAttributeValue>
{
        \"                      { yybegin(DQ_STRING); string.setLength(0); }
        \'                      { yybegin(SQ_STRING); string.setLength(0); }
        // in this state, anything other than a space character can start an undelimited string
        {S}*.           { yypushback(1); yybegin(UnDelimitedString); string.setLength(0);}

}


<DQ_STRING>
{

        \"                      { popState(); valueText = string.toString(); return EncodingParserConstants.StringValue; }
        {LineTerminator}        { yypushback(1);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}
        "\?>"                   { yypushback(2); popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}
        '<'                     { yypushback(1);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}
        .                       { string.append( yytext() ); }

        "%>"                    { yypushback(2);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}


}

<SQ_STRING>
{

        \'                      { popState(); valueText = string.toString(); return EncodingParserConstants.StringValue;}
        {LineTerminator}        { yypushback(1);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}
        "%>"                    { yypushback(2);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}
        '<'                     { yypushback(1);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}
        .                       { string.append( yytext() ); }
        "%>"                    { yypushback(2);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}


}

<UnDelimitedString>
{


        {S}                     { yypushback(1);popState(); valueText = string.toString(); return EncodingParserConstants.UnDelimitedStringValue; }
        {LineTerminator}        { yypushback(1);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}
        "\?>"                   { yypushback(2);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}
        '<'                     { yypushback(1);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}
        // these are a bit special, since we started an undelimit string, but found a quote ... probably indicates a missing beginning quote
        \'                      { yypushback(1);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTermintatedUnDelimitedStringValue;}
        \"                      { yypushback(1);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTermintatedUnDelimitedStringValue;}

        .                       { string.append( yytext() ); }
        "%>"                    { yypushback(2);popState(); valueText = string.toString(); return EncodingParserConstants.InvalidTerminatedStringValue;}

}

// The "match anything" rule should always be in effect except for when looking for end of string
// (That is, remember to update state list if/when new states added)
<YYINITIAL, ST_XMLDecl, QuotedAttributeValue, ST_PAGE_DIRECTIVE>
{
// this is the fallback (match "anything") rule  (for this scanner, input is ignored, and position advanced, if not recognized)
.|\n              {if (yychar > MAX_TO_SCAN) {hasMore=false; return EncodingParserConstants.MAX_CHARS_REACHED;}}
}

// this rule always in effect
<<EOF>>         {hasMore = false; return EncodingParserConstants.EOF;}

