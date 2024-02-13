// Import the necessary modules
import { expect, test } from "bun:test";

// Import the functions to test
import { generateTypeScriptCodeFromSVG,flattenSVG, getStyle  } from "./convert-svg-to-gg.ts";

// Test cases for the generateTypeScriptCodeFromSVG function
test("Generated TypeScript code for SVG circle element", () => {
    const svgDocument = `<svg width="200" height="200">
        <circle cx="50" cy="50" r="40" style="fill: red; stroke: black" />
    </svg>`;
    const expectedCode = `const cfg: Config = {
    width: 200,
    height: 200,
};
const ctx = new_context(cfg);

ctx.draw_circle_filled(50, 50, 40, gx.Color{r: red, stroke_color: black});
`;
    expect(generateTypeScriptCodeFromSVG(svgDocument)).toBe(expectedCode);
});

test("Generated TypeScript code for SVG rect element", () => {
    const svgDocument = `<svg width="200" height="200">
        <rect x="20" y="100" width="100" height="50" style="fill: blue" />
    </svg>`;
    const expectedCode = `const cfg: Config = {
    width: 200,
    height: 200,
};
const ctx = new_context(cfg);

ctx.draw_rect_filled(20, 100, 100, 50, gx.Color{r: blue});
`;
    expect(generateTypeScriptCodeFromSVG(svgDocument)).toBe(expectedCode);
});

test("Generated TypeScript code for SVG ellipse element", () => {
    const svgDocument = `<svg width="200" height="200">
        <ellipse cx="150" cy="150" rx="40" ry="30" style="fill: green" />
    </svg>`;
    const expectedCode = `const cfg: Config = {
    width: 200,
    height: 200,
};
const ctx = new_context(cfg);

ctx.draw_ellipse_filled(150, 150, 40, 30, gx.Color{r: green});
`;
    expect(generateTypeScriptCodeFromSVG(svgDocument)).toBe(expectedCode);
});

test("Generated TypeScript code for SVG polyline element", () => {
    const svgDocument = `<svg width="200" height="200">
        <polyline points="10,10 20,30 30,15" style="stroke: black; fill: none" />
    </svg>`;
    const expectedCode = `const cfg: Config = {
    width: 200,
    height: 200,
};
const ctx = new_context(cfg);

ctx.draw_poly_empty([[10, 10], [20, 30], [30, 15]], gx.Color{stroke_color: black});
`;
    expect(generateTypeScriptCodeFromSVG(svgDocument)).toBe(expectedCode);
});

test("Generated TypeScript code for SVG text element", () => {
    const svgDocument = `<svg width="200" height="200">
        <text x="50" y="50" style="font: bold 16px Arial; fill: red">Hello, TypeScript!</text>
    </svg>`;
    const expectedCode = `const cfg: Config = {
    width: 200,
    height: 200,
};
const ctx = new_context(cfg);

ctx.draw_text(50, 50, "Hello, TypeScript!", gx.TextCfg{font: "bold 16px Arial", r: red});
`;
    expect(generateTypeScriptCodeFromSVG(svgDocument)).toBe(expectedCode);
});

test("Generated TypeScript code for SVG img element", () => {
    const svgDocument = `<svg width="200" height="200">
        <img x="100" y="100" width="50" height="50" href="image.jpg" />
    </svg>`;
    const expectedCode = `const cfg: Config = {
    width: 200,
    height: 200,
};
const ctx = new_context(cfg);

ctx.draw_image(100, 100, 50, 50, load_image("image.jpg"));
`;
    expect(generateTypeScriptCodeFromSVG(svgDocument)).toBe(expectedCode);
});

// Test cases for the flattenSVG function
test("Flatten SVG structure", () => {
    const svgDocument = `<svg width="200" height="200">
        <g>
            <circle cx="50" cy="50" r="40" style="fill: red; stroke: black" />
        </g>
        <g style="fill: blue">
            <rect x="20" y="100" width="100" height="50" />
        </g>
    </svg>`;
    const expectedSVG = `<svg width="200" height="200">
        <circle cx="50" cy="50" r="40" style="fill: red; stroke: black" />
        <rect x="20" y="100" width="100" height="50" style="fill: blue" />
    </svg>`;
    const parser = new DOMParser();
    const doc = parser.parseFromString(svgDocument, 'image/svg+xml');
    const svg = doc.getElementsByTagName('svg')[0];
    flattenSVG(svg);
    expect(svg.outerHTML).toBe(expectedSVG);
});

// Test cases for the getStyle function
test("Extract fill, stroke, and font styles", () => {
    const element = document.createElement('circle');
    element.setAttribute('style', 'fill: red; stroke: black; font: bold 16px Arial');
    const expectedStyle = `r: red, stroke_color: black, font: "bold 16px Arial", `;
    expect(getStyle(element)).toBe(expectedStyle);
});
