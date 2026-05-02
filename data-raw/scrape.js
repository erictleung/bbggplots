// Scrape the Brooklyn Botanic Garden website
// Run: node scrape.js

const https = require('https');
const fs = require('fs');

let targetDate;
let targetUrl;

// Try and accessing the last element of a JSON file with all the data
try {
  // 1. Read and parse the file
  const rawData = fs.readFileSync('archive.json', 'utf8');
  const jsonData = JSON.parse(rawData);

  if (Array.isArray(jsonData) && jsonData.length > 0) {
    // 3. Access the last element
    // .at(-1) is the modern, clean way to get the last item
    const lastElement = jsonData.at(-1)

    // 4. Access the date and URL attribute
    targetDate = lastElement.date;
    targetUrl = lastElement.url;

    if (targetUrl) {
      console.log('The URL of the last element is:', targetUrl);
    } else {
      console.log('The last element exists, but it has no "url" attribute.');
    }

  } else {
    console.log('The JSON file is empty or not an array.');
  }
} catch (err) {
  console.error('Error:', err.message);
}
console.log(targetUrl);

https.get(targetUrl, (res) => {
  let html = '';

  res.on('data', (chunk) => { html += chunk; });

  res.on('end', () => {
    try {
      // 1. Locate the array in the HTML. 
      // This Regex looks for "const myData = [ ... ];"
      // Change 'myData' to the actual name of the variable on the site.
      const regex = /var\s+prunuses\s*=\s*(\[[\s\S]*?\]);/;
      const match = html.match(regex);

      if (match && match[1]) {
        const arrayString = match[1];

        // 2. Safely parse the string (or use JSON.parse if it's strictly formatted)
        // We use a Function constructor here to evaluate the string as JS
        const dataArray = new Function(`return ${arrayString}`)();

        // 3. Write to local JSON file
        fs.writeFileSync(`cherries_${targetDate}.json`, JSON.stringify(dataArray, null, 2));
        console.log(`File saved successfully as cherries_${targetDate}.json!`);
      } else {
        console.log('Could not find the array in the HTML source.');
      }
    } catch (err) {
      console.error('Error parsing the array:', err.message);
    }
  });

}).on('error', (err) => {
  console.error('Error fetching the page:', err.message);
});
