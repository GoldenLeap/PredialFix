<?php

namespace App\Notifications;

use App\Models\Material;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;

/**
 * Notificação enviada aos admins/responsáveis quando um material fica abaixo do estoque mínimo.
 * Canais: mail (email via Mailpit) + database (sininho 🔔).
 */
class EstoqueCritico extends Notification implements ShouldQueue
{
    use Queueable;

    protected Material $material;

    public function __construct(Material $material)
    {
        $this->material = $material;
    }

    public function via(object $notifiable): array
    {
        return ['mail', 'database'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject("Estoque Crítico: {$this->material->nome}")
            ->greeting("Olá {$notifiable->name}!")
            ->line("O estoque do seguinte material atingiu nível crítico:")
            ->line("**Material:** {$this->material->nome}")
            ->line("**Categoria:** {$this->material->categoria}")
            ->line("**Quantidade atual:** {$this->material->quantidade_atual} {$this->material->unidade}")
            ->line("**Quantidade mínima:** {$this->material->quantidade_minima} {$this->material->unidade}")
            ->line("**Localização:** " . ($this->material->localizacao ?? 'Não informada'))
            ->line('Por favor, providencie a reposição do estoque o mais breve possível.')
            ->action('Ver Materiais', url('/materiais'))
            ->salutation('Atenciosamente, PredialFix');
    }

    public function toArray(object $notifiable): array
    {
        return [
            'material_id' => $this->material->id,
            'tipo' => 'estoque_critico',
            'material_nome' => $this->material->nome,
            'categoria' => $this->material->categoria,
            'quantidade_atual' => $this->material->quantidade_atual,
            'quantidade_minima' => $this->material->quantidade_minima,
            'unidade' => $this->material->unidade,
            'mensagem' => "Estoque crítico: {$this->material->nome} ({$this->material->quantidade_atual}/{$this->material->quantidade_minima} {$this->material->unidade})",
        ];
    }
}
