import jsdom from "jsdom"

const log = function(...args:any[]) {
    let place = ((new Error()).stack?.split("\n").slice(2,4)||[]).map(t => t.substring(7));
    let time = new Date().toISOString()
    console.log(place,time,...args)
}
export function generateTypeScriptCodeFromSVG(svgDocument: string): string {
    let tsCode = '';

    // Parse the SVG document
    const dom = new jsdom.JSDOM(svgDocument);
    const svg = dom.window.document.querySelector('svg')!!;

    // Flatten SVG structure by inlining styles and classes from parent groups
    //flattenSVG(svg,svg);

    // Extract width and height from SVG element
    const width = parseFloat(svg.getAttribute('width')!);
    const height = parseFloat(svg.getAttribute('height')!);

    // Generate TypeScript code for setting up context with appropriate width and height
    tsCode += `const cfg: Config = {
    width: ${width},
    height: ${height},
};\n`;
    tsCode += `const ctx = new_context(cfg);\n\n`;
    // tsCode += `// children: ${svg.children.length}\n\n`;
    const translatableElements = Array.from(svg.querySelectorAll("image,circle,rect,ellipse,polyline,text,img"))
    log("found elements",translatableElements.map(n => n.tagName))
    // Iterate through each child element of the SVG
    for (const element of translatableElements) {
        // Extract element type and attributes
        const elementType = (element as Element).tagName.toLowerCase();
        const attributes: { [key: string]: string } = {};
        for (const attr of Array.from((element as Element).attributes)) {
            attributes[attr.name] = attr.value;
        }
        // tsCode += `/// fcode generated for <${elementType} ${JSON.stringify(attributes).replace(/"/gi,"")}/>`
        // Generate TypeScript code based on element type
        switch (elementType) {
            case 'circle':
                tsCode += `ctx.draw_circle_filled(${attributes.cx}, ${attributes.cy}, ${attributes.r}, gx.Color{${getStyle(element as Element)}});\n`;
                break;
            case 'rect':
                tsCode += `ctx.draw_rect_filled(${attributes.x}, ${attributes.y}, ${attributes.width}, ${attributes.height}, gx.Color{${getStyle(element as Element)}});\n`;
                break;
            case 'ellipse':
                tsCode += `ctx.draw_ellipse_filled(${attributes.cx}, ${attributes.cy}, ${attributes.rx}, ${attributes.ry}, gx.Color{${getStyle(element as Element)}});\n`;
                break;
            case 'polyline':
                // Assuming points attribute is formatted as "x1,y1 x2,y2 x3,y3 ..."
                const points = attributes.points
                    .split(' ')
                    .map(point => point.split(',').map(parseFloat))
                    .flatMap(n => n);
                tsCode += `ctx.draw_poly_empty([${points.map((d,i) => {
                    if(i==0) {
                        return `f64(${d})`
                    } else {
                        return `${d}`
                    }
                }).join(",")}], gx.Color{${getStyle(element as Element)}});\n`;
                break;
            case 'text':
                tsCode += `ctx.draw_text(${attributes.x}, ${attributes.y}, "${(element as Element).textContent}", gx.TextCfg{${getStyle(element as Element)}});\n`;
                break;
            case 'img':
                // Assuming image source is encoded in href attribute
                tsCode += `ctx.draw_image(${attributes.x}, ${attributes.y}, ${attributes.width}, ${attributes.height}, load_image("${attributes.href}"));\n`;
                break;
            default :
                tsCode += `// unhandled element ${elementType} ${JSON.stringify(attributes).replace(/"/gi,"")} ;\n`;
            // Handle other SVG elements similarly
        }
    }

    return tsCode;
}

export function flattenSVG(element: Element,svg: Element) {
    // Inline styles and classes from parent groups
    if (element.tagName.toLowerCase() === 'g') {
        for (const child of Array.from(element.children)) {
            for (const attr of Array.from(element.attributes)) {
                if (attr.name === 'style') {
                    (child as Element).setAttribute('style', `${(child as Element).getAttribute('style') || ''} ${attr.value}`);
                } else if (attr.name === 'class') {
                    (child as Element).setAttribute('class', `${(child as Element).getAttribute('class') || ''} ${attr.value}`);
                }
            }
            svg.appendChild(child)
            flattenSVG(child as Element,svg);
        }
    }
}

export function getStyle(element: Element) {
    // Extract fill, stroke, and font styles from element
    const style = element.getAttribute('style') || '';
    const fill = style.match(/fill:\s*(.*?)(;|$)/);
    const stroke = style.match(/stroke:\s*(.*?)(;|$)/);
    const font = style.match(/font:\s*(.*?)(;|$)/);
    let styleCode = '';
    if (fill) styleCode += `r: ${fill[1]}, `;
    if (stroke) styleCode += `stroke_color: ${stroke[1]}, `;
    if (font) styleCode += `font: "${font[1]}", `;
    return styleCode;
}

// Example usage
const svgDocument = `<svg width="200" height="200">
    <circle cx="50" cy="50" r="40" style="fill: red; stroke: black" />
    <rect x="20" y="100" width="100" height="50" style="fill: blue" />
    <ellipse cx="150" cy="150" rx="40" ry="30" style="fill: green" />
    <polyline points="10,10 20,30 30,15" style="stroke: black; fill: none" />
    <text x="50" y="50" style="font: bold 16px Arial; fill: red">Hello, TypeScript!</text>
    <img x="100" y="100" width="50" height="50" href="image.jpg" />
</svg>`;

const tsCode = generateTypeScriptCodeFromSVG(svgDocument);
log(tsCode);
