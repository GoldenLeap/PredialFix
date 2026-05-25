<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BudgetConfig extends Model
{
    protected $fillable = [
        'month',
        'year',
        'total_budget',
        'allocations',
        'alert_enabled',
    ];

    protected $casts = [
        'allocations' => 'array',
        'alert_enabled' => 'boolean',
    ];
}
