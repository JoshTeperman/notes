@import url('./learning_html.css');
@import url('./cards.css');

/* To center */
/* Wrap in a div */
/* Set max-width */
/* Set margin: 0 auto; on child element --> only works on child element of parent-child pair */

/* To center divs in parent div */
/* sent parent div to text-align: center; */
/* set child div to display: inline-block */
/* probably: set width of child div */

/* don't use relative and absolute position not used often, but used with cards */

/* elements */

body {
  margin: 0px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
}

a {
  color: dodgerblue;
}

/* almost never touch the body, use a container instead */

/* ID's */

/* when setting whole-screen boxes, set height: 100vh; > width is automatically width of container */

#container {
max-width: 700px;
margin: 0 auto;
}

#container p {
  font-size: 18px;
  line-height: 1.4;
}

#container h1 {
  font-size: 24px;
  border-bottom: 1px dotted black;
}

/* Classes */

.header-link {
  text-decoration: none;
  color: black
}

/* backgrounds & with gradient */

.container {
  margin 0px;
  background: linear-gradient(black, black), url('./image.jpg');
  height: 100vh;
  background-position: center;
  background-size: cover;
  background-repeat: no-repeat;
}

/* (linear-gradient(to bottomk, colour, transparent) */

/* Components: 
For us, most imporant are Buttons, Cards, Badges, Labels */

/* Cards */
/* position relative: parent div will be positioned relative. Once you make parent element position relative*/
/* 
position: absolute;
right: 20px;
left: 20px;
 */

 /* PSUEDO CLASS: control styling when element is in a particular state */
 /* eg: 
 hover
 a:link
 a:visited
 a:active
 a:focus
 */


CSS VARIABLES / COLOUR SCHEMES:
/* css variables used to created colour schemes:
:root {
  --blue: #1117A3;
  --purple: #824D51;
}

.container {
  height: 100vh;
  background var(--blue);
}
*/

FLEX-BOX;

/* 
give parent element control over children element position
parent is always the flex box. 
child elements just set size / colour etc.

eg: 
parent element {
  height: 100vh;
  display: flex
  justify-content; center; << x-axis
  align-items: center; << y-axis
}
can create a flex-box, name that element with class, then target that class with display: grid to add 2 dimensions.

align-items: << y-axis
flex-start  
center      
flex-end    

justify-content: << x-axis
flex-start    center    flex-end
space-around
space-between
space-evenly


display: flex;
flex-direction: column; << vertical boxes
flex-direction: row; << horizontal boxes
flex-wrap: wrap; << by default won't wrap, will make boxes smaller, therefore wrap. Also makes it responsive
flex-direction: row-reverse; backwards (first item will be last)
flex-direction: column-reverse;

ALIGN-CONTENT
Similar to align items, but will align the whole block to the container
Align-content: spacing between the lines / align-items: item alignment within the container
Therefore when only one line, align content has no effect
Default is stretch (whole y-axis)

eg: align-content: 
flex-start (will bunch blocks to top of container (remove stretch spacing)
center
flex-end

ORDER:
.item-class {
  order: integer;
}
>> order: -1; will always be first

ALIGN-SELF

.item-class {
  align-item: flex-start, center, flex-end;
}

COMMON USE CASE:
checkout flexbox grid system libraries
figma
art board, new frame, desktop > layout grid > column grid > select # of columns (12)

search: rulers > on

*/
DISPLAY SUMMARY:

 /* 
display: block; takes up the whole width of whatever parent element
display: inline; takes up the size of the content
display: inline-block; also respects height and width of the container, top-bottom padding and margin 
display: none; makes it invisible (drop-down button, media queries)
visibility: hidden << does the same as display: none;

flex: positions elements within the parent flex-box


*/

DISPLAY GRID:

/* 
>> create wireframe: 
display: grid;
grid-template-columns: 1000px, 300px, 
grid-template-rows: repeat(3, 1fr);


*/

nth Child:
/* 
sidebar-link:nth-child(1) {
  margin: 14px
}  
   */


MEDIA QUERIES:

 /* 
 
 @media only screen and (max-width: 800px) {
  * anything below 800 px width display with these styles
  use display: none; if want to delete files
 }  

/* Extra small devices (phones, 600px and down) */
/* @media only screen and (max-width: 600px) {...}  */

/* Small devices (portrait tablets and large phones, 600px and up) */
/* @media only screen and (min-width: 600px) {...}  */

/* Medium devices (landscape tablets, 768px and up) */
/* @media only screen and (min-width: 768px) {...}  */

/* Large devices (laptops/desktops, 992px and up) */
/* @media only screen and (min-width: 992px) {...}  */

/* Extra large devices (large laptops and desktops, 1200px and up) */
/* @media only screen and (min-width: 1200px) {...} */


