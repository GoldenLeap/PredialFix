<?php

namespace App\Notifications;

use App\Models\Chamado;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;

class ChamadoStatusChanged extends Notification implements ShouldQueue
{
    use Queueable;

    protected Chamado $chamado;
    protected string $statusAnterior;
    protected string $statusNovo;

    public function __construct(Chamado $chamado, string $statusAnterior, string $statusNovo)
    {
        $this->chamado = $chamado;
        $this->statusAnterior = $statusAnterior;
        $this->statusNovo = $statusNovo;
    }

    public function via(object $notifiable): array
    {
        return ['mail', 'database'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        $url = url("/chamados/{$this->chamado->id}");
        
        return (new MailMessage)
            ->subject("Chamado #{$this->chamado->id} - Status Atualizado")
            ->greeting("Olá {$notifiable->name}!")
            ->line("O status do chamado #{$this->chamado->id} foi alterado:")
            ->line("De: {$this->statusAnterior}")
            ->line("Para: {$this->statusNovo}")
            ->line("Solicitante: {$this->chamado->user->name}")
            ->line("Email: {$this->chamado->user->email}")
            ->line("Bloco: " . ($this->chamado->bloco ?? '-'))
            ->line("Prioridade: {$this->chamado->prioridade}")
            ->action('Ver Chamado', $url)
            ->line('Obrigado por usar o PredialFix!');
    }

    public function toArray(object $notifiable): array
    {
        return [
            'chamado_id' => $this->chamado->id,
            'status_anterior' => $this->statusAnterior,
            'status_novo' => $this->statusNovo,
            'prioridade' => $this->chamado->prioridade,
            'bloco' => $this->chamado->bloco,
            'solicitante_nome' => $this->chamado->user->name,
            'solicitante_email' => $this->chamado->user->email,
        ];
    }
}