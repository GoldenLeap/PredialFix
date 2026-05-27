<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Notificação de Chamado</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 2px solid #ED1C24;
        }
        .header h1 {
            color: #ED1C24;
            margin: 0;
            font-size: 24px;
        }
        .content {
            padding: 20px 0;
        }
        .info-row {
            margin-bottom: 15px;
        }
        .info-label {
            font-weight: bold;
            color: #666;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            color: #333;
            font-size: 16px;
            margin-top: 5px;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
        }
        .status-aberto { background: #e8f0fe; color: #007BFF; }
        .status-analise { background: #fff3e0; color: #F2994A; }
        .status-execucao { background: #e8f0fe; color: #007BFF; }
        .status-concluido { background: #e8f5e9; color: #27AE60; }
        .button {
            display: inline-block;
            background: #007BFF;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: bold;
            margin-top: 20px;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            font-size: 12px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Notificação de Chamado</h1>
        </div>
        
        <div class="content">
            <p>Olá {{ $notifiable->name }},</p>
            
            <p>O status do chamado foi alterado:</p>
            
            <div class="info-row">
                <div class="info-label">Chamado</div>
                <div class="info-value">#{{ $chamado->id }}</div>
            </div>
            
            <div class="info-row">
                <div class="info-label">Status Anterior</div>
                <div class="info-value">{{ $statusAnterior }}</div>
            </div>
            
            <div class="info-row">
                <div class="info-label">Novo Status</div>
                <div class="info-value">
                    <span class="status-badge status-{{ strtolower(str_replace(' ', '-', $statusNovo)) }}">
                        {{ $statusNovo }}
                    </span>
                </div>
            </div>
            
            <div class="info-row">
                <div class="info-label">Solicitante</div>
                <div class="info-value">{{ $chamado->user->name }}</div>
            </div>
            
            <div class="info-row">
                <div class="info-label">Email do Solicitante</div>
                <div class="info-value">{{ $chamado->user->email }}</div>
            </div>
            
            <div class="info-row">
                <div class="info-label">Bloco</div>
                <div class="info-value">{{ $chamado->bloco ?? '-' }}</div>
            </div>
            
            <div class="info-row">
                <div class="info-label">Prioridade</div>
                <div class="info-value">{{ $chamado->prioridade }}</div>
            </div>
        </div>
        
        <a href="{{ url('/chamados/' . $chamado->id) }}" class="button">Ver Chamado</a>
        
        <div class="footer">
            <p>PredialFix - Sistema de Manutenção Predial</p>
        </div>
    </div>
</body>
</html>