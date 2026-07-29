<?php

namespace App\Http\Controllers\Api;

use App\Actions\Discussion\DeleteDiscussionAction;
use App\Actions\Discussion\PostDiscussionAction;
use App\Actions\Discussion\UpdateDiscussionAction;
use App\Http\Controllers\Controller;
use App\Http\Resources\DiscussionResource;
use App\Models\Discussion;
use App\Services\DiscussionService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class DiscussionController extends Controller
{
    use ApiResponse;

    public function __construct(protected DiscussionService $discussionService)
    {
    }

    public function index(Request $request)
    {
        $discussions = $this->discussionService->listForApi($request->only(['class_code']));

        return $this->success(DiscussionResource::collection($discussions));
    }

    public function store(Request $request, PostDiscussionAction $action)
    {
        $request->validate([
            'class_code' => 'required|string',
            'message'    => 'required|string',
        ]);

        $classroom = $this->discussionService->findClassByCode($request->class_code);

        if (!$classroom) {
            return $this->notFound('Kelas tidak ditemukan.');
        }

        $discussion = $action->execute([
            'class_id' => $classroom->id,
            'user_id'  => auth()->id(),
            'message'  => $request->message,
        ]);

        return $this->success($discussion, 'Diskusi berhasil ditambahkan.');
    }

    public function show(Discussion $discussion)
    {
        $discussion->load(['classroom', 'user']);

        return $this->success(new DiscussionResource($discussion));
    }

    public function update(Request $request, Discussion $discussion, UpdateDiscussionAction $action)
    {
        $request->validate([
            'message' => 'required|string',
        ]);

        $discussion = $action->execute($discussion, ['message' => $request->message]);

        return $this->success($discussion, 'Diskusi berhasil diperbarui.');
    }

    public function destroy(Discussion $discussion, DeleteDiscussionAction $action)
    {
        $action->execute($discussion);

        return $this->success(null, 'Diskusi berhasil dihapus.');
    }
}
