const express = require("express");
const app = express();
const PORT = 8080;

// Ruta principal que genera una página interactiva de monitoreo
app.get("/", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Control de Infraestructura</title>
        <style>
            body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #0f172a; color: #f8fafc; margin: 0; padding: 40px; display: flex; flex-direction: column; align-items: center; }
            .card { background: #1e293b; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.3); width: 100%; max-width: 500px; text-align: center; border: 1px solid #334155; }
            h1 { color: #38bdf8; margin-bottom: 5px; }
            .status-badge { background: #10b981; color: white; padding: 5px 15px; border-radius: 20px; font-size: 0.9em; display: inline-block; margin-bottom: 25px; font-weight: bold; }
            .metric { margin: 20px 0; text-align: left; }
            .metric-label { font-size: 0.9em; color: #94a3b8; margin-bottom: 5px; display: flex; justify-content: space-between; }
            .progress-bar { background: #334155; height: 12px; border-radius: 6px; overflow: hidden; }
            .progress-fill { background: #38bdf8; height: 100%; width: 0%; transition: width 1s ease-in-out; }
            .version { margin-top: 30px; font-size: 0.8em; color: #64748b; font-family: monospace; }
        </style>
    </head>
    <body>
        <div class="card">
            <h1>Server Monitor</h1>
            <div class="status-badge">SISTEMA ONLINE</div>
            
            <div class="metric">
                <div class="metric-label"><span>Uso de CPU</span><span id="cpu-text">0%</span></div>
                <div class="progress-bar"><div id="cpu-bar" class="progress-fill" style="background: #ef4444;"></div></div>
            </div>
            <div class="metric">
                <div class="metric-label"><span>Memoria RAM</span><span id="ram-text">0%</span></div>
                <div class="progress-bar"><div id="ram-bar" class="progress-fill" style="background: #f59e0b;"></div></div>
            </div>
            
            <div class="version">Despliegue: v1.0.0 (Manual)</div>
        </div>

        <script>
            // Simulación interactiva de métricas en tiempo real en el navegador
            setInterval(() => {
                const cpu = Math.floor(Math.random() * (45 - 15 + 1)) + 15;
                const ram = Math.floor(Math.random() * (75 - 60 + 1)) + 60;
                
                document.getElementById('cpu-text').innerText = cpu + '%';
                document.getElementById('cpu-bar').style.width = cpu + '%';
                
                document.getElementById('ram-text').innerText = ram + '%';
                document.getElementById('ram-bar').style.width = ram + '%';
            }, 2000);
        </script>
    </body>
    </html>
    `);
});

app.listen(PORT, () => {
  console.log(`Aplicación ejecutándose por http://localhost:${PORT}`);
});
