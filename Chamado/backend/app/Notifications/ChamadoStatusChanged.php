<?php

namespace App\Notifications;

use App\Models\Chamado;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;

/**
 * Notificação disparada quando o status de um chamado muda.
 * Enviada ao solicitante via mail
 */
class ChamadoStatusChanged extends Notification implements ShouldQueue
{
    use Queueable;

    protected Chamado $chamado;
    protected string $statusAnterior;
    protected string $statusNovo;

    /** Mensagens de progresso humanizadas por status. */
    private const MENSAGENS_PROGRESSO = [
        'Em Análise' => 'Seu chamado está sendo analisado pela equipe técnica.',
        'Aguardando Material' => 'Aguardando chegada de material necessário para o serviço.',
        'Em Execução' => 'Técnico a caminho. O serviço foi iniciado!',
        'Concluído' => 'Serviço finalizado. Chamado encerrado com sucesso!',
        'Aberto' => 'Chamado foi reaberto para nova análise.',
    ];

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
        $solicitante = $this->chamado->user?->name ?? 'Usuário desconhecido';
        $email = $this->chamado->user?->email ?? '-';
        $mensagemProgresso = self::MENSAGENS_PROGRESSO[$this->statusNovo] ?? '';

        return (new MailMessage)
            ->subject("Chamado #{$this->chamado->id} — {$this->statusAnterior} → {$this->statusNovo}")
            ->greeting("Olá {$notifiable->name}!")
            ->line("O status do chamado #{$this->chamado->id} foi atualizado:")
            ->line("**De:** {$this->statusAnterior}")
            ->line("**Para:** {$this->statusNovo}")
            ->when($mensagemProgresso, fn (MailMessage $mail) => $mail->line($mensagemProgresso))
            ->line("---")
            ->line("**Assunto:** " . ($this->chamado->assunto ?? '-'))
            ->line("**Solicitante:** {$solicitante} ({$email})")
            ->line("**Local:** " . ($this->chamado->local ?? '-'))
            ->line("**Bloco:** " . ($this->chamado->bloco ?? '-'))
            ->line("**Prioridade:** " . ($this->chamado->prioridade ?? '-'))
            ->action('Ver Chamado', $url)
            ->line('Obrigado por usar o PredialFix!');
    }

    public function toArray(object $notifiable): array
    {
        return [
            'chamado_id' => $this->chamado->id,
            'tipo' => 'status_alterado',
            'status_anterior' => $this->statusAnterior,
            'status_novo' => $this->statusNovo,
            'assunto' => $this->chamado->assunto,
            'prioridade' => $this->chamado->prioridade,
            'bloco' => $this->chamado->bloco,
            'solicitante_nome' => $this->chamado->user?->name ?? 'Desconhecido',
            'solicitante_email' => $this->chamado->user?->email ?? '-',
            'mensagem' => self::MENSAGENS_PROGRESSO[$this->statusNovo]
                ?? "Chamado #{$this->chamado->id} atualizado para {$this->statusNovo}",
        ];
    }
}