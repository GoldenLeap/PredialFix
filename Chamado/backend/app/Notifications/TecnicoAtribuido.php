<?php

namespace App\Notifications;

use App\Models\Chamado;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;

/**
 * Notificação enviada ao técnico quando ele é designado para um chamado.
 * Canais: mail (email via Mailpit) + database (sininho 🔔).
 */
class TecnicoAtribuido extends Notification implements ShouldQueue
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

        return (new MailMessage)
            ->subject("🔧 Você foi designado para o Chamado #{$this->chamado->id}")
            ->greeting("Olá {$notifiable->name}!")
            ->line("Você foi designado como técnico responsável pelo seguinte chamado:")
            ->line("**Assunto:** {$this->chamado->assunto}")
            ->line("**Tipo:** {$this->chamado->tipo}")
            ->line("**Local:** {$this->chamado->local}")
            ->line("**Bloco:** " . ($this->chamado->bloco ?? 'Não informado'))
            ->line("**Prioridade:** {$this->chamado->prioridade}")
            ->line("**Status atual:** {$this->chamado->status}")
            ->action('Ver Chamado', $url)
            ->line('Por favor, analise o chamado e atualize o status conforme necessário.');
    }

    public function toArray(object $notifiable): array
    {
        return [
            'chamado_id' => $this->chamado->id,
            'tipo' => 'tecnico_atribuido',
            'assunto' => $this->chamado->assunto,
            'tipo_chamado' => $this->chamado->tipo,
            'prioridade' => $this->chamado->prioridade,
            'local' => $this->chamado->local,
            'mensagem' => "Você foi designado para o chamado #{$this->chamado->id}: {$this->chamado->assunto}",
        ];
    }
}
