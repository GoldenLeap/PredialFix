<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        if ($request->expectsJson()) {
            return response()->json($request->user()->unreadNotifications);
        }
        return back();
    }

    public function markAsRead(Request $request, $id)
    {
        $notification = $request->user()->notifications()->findOrFail($id);
        $notification->markAsRead();
        
        if ($request->expectsJson()) {
            return response()->json(['message' => 'Notificação marcada como lida']);
        }
        return back();
    }

    public function markAllAsRead(Request $request)
    {
        $request->user()->unreadNotifications->markAsRead();
        
        if ($request->expectsJson()) {
            return response()->json(['message' => 'Todas as notificações marcadas como lidas']);
        }
        return back();
    }
}
