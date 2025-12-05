<?php

declare(strict_types=1);

namespace App\UserInterface\Web;

use App\Domain\User\Port\UserApiClientInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Request;

#[Route('/api/users')]
class UserController extends AbstractController
{
    private UserApiClientInterface $userApi;

    public function __construct(UserApiClientInterface $userApi)
    {
        $this->userApi = $userApi;
    }

    #[Route('', name: 'list_users', methods: ['GET'])]
    public function list(Request $request): JsonResponse
    {
        $filters = $request->query->all();
        
        return $this->json($this->userApi->list($filters));
    }

    #[Route('/{id}', name: 'get_user', methods: ['GET'])]
    public function get(string $id): JsonResponse
    {
        $user = $this->userApi->get($id);
        if (!$user) return $this->json(['error' => 'Not found'], 404);

        return $this->json($user);
    }

    #[Route('', name: 'create_user', methods: ['POST'])]
    public function create(Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        return $this->json($this->userApi->create($data));
    }

    #[Route('/{id}', name: 'update_user', methods: ['PUT'])]
    public function update(string $id, Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        return $this->json($this->userApi->update($id, $data));
    }

    #[Route('/{id}', name: 'delete_user', methods: ['DELETE'])]
    public function delete(string $id): JsonResponse
    {
        $deleted = $this->userApi->delete($id);

        return $this->json(null, $deleted ? 204 : 404);
    }

    #[Route('/import', name: 'import_users', methods: ['POST'])]
    public function import(Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        return $this->json($this->userApi->import($data));
    }
}