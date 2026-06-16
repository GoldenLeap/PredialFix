<?php

namespace App\Notifications;

use App\Models\Chamado;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;

/**
 * Notificação enviada aos admins/responsáveis quando um novo chamado é aberto.
 * Canais: mail (email via Mailpit) + database (sininho 🔔).
 */
class ChamadoCreated extends Notification implements ShouldQueue
{
    use Queueable;

    protected Chamado $chamado;

    public function __construct(Chamado $chamado)
    {
        $this->chamado = $chamado;
    }

    public function via(object $notifiable): array
    {
        return ['mail', 'database'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        $url = url("/chamados/{$this->chamado->id}");
        $solicitante = $this->chamado->user?->name ?? 'Usuário desconhecido';
        $email = $this->chamado->user?->email ?? '-';

        return (new MailMessage)
            ->subject("🆕 Novo Chamado #{$this->chamado->id} — {$this->chamado->tipo}")
            ->greeting("Olá {$notifiable->name}!")
            ->line("Um novo chamado de manutenção foi aberto e requer sua atenção.")
            ->line("**Assunto:** {$this->chamado->assunto}")
            ->line("**Tipo:** {$this->chamado->tipo}")
            ->line("**Local:** {$this->chamado->local}")
            ->line("**Bloco:** " . ($this->chamado->bloco ?? 'Não informado'))
            ->line("**Prioridade:** {$this->chamado->prioridade}")
            ->line("**Solicitante:** {$solicitante} ({$email})")
            ->line("**Descrição:** " . \Illuminate\Support\Str::limit($this->chamado->descricao, 200))
            ->action('Ver Chamado', $url)
            ->line('Obrigado por usar o PredialFix!');
    }

    public function toArray(object $notifiable): array
    {
        return [
            'chamado_id' => $this->chamado->id,
            'tipo' => 'novo_chamado',
            'assunto' => $this->chamado->assunto,
            'tipo_chamado' => $this->chamado->tipo,
            'prioridade' => $this->chamado->prioridade,
            'local' => $this->chamado->local,
            'bloco' => $this->chamado->bloco,
            'solicitante_nome' => $this->chamado->user?->name ?? 'Desconhecido',
            'mensagem' => "Novo chamado #{$this->chamado->id} aberto: {$this->chamado->assunto}",
        ];
    }
}
